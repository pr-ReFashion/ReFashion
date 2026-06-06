// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

/**
 * @title ReFashionToken (RFT)
 * @notice ERC-20 reward token for the ReFashion sustainability platform.
 *
 * Design decisions:
 * - No public transfer: tokens are only minted/burned by the backend (custodial model).
 *   Users never move tokens themselves, so we disable transfer to prevent misuse.
 * - Role-based access: only wallets granted MINTER_ROLE can mint/burn.
 *   The deployer gets ADMIN_ROLE and can grant/revoke roles.
 * - Pausable: PAUSER_ROLE can halt all minting/burning in an emergency.
 * - 18 decimals (ERC-20 default). 1 RFT = 1e18 base units.
 *   The API layer deals in whole tokens and multiplies by 1e18 before calling the contract.
 */
contract ReFashionToken is ERC20, ERC20Pausable, AccessControl {
    // ─── Roles ──────────────────────────────────────────────────────────────
    bytes32 public constant MINTER_ROLE  = keccak256("MINTER_ROLE");
    bytes32 public constant PAUSER_ROLE  = keccak256("PAUSER_ROLE");

    // ─── Events ─────────────────────────────────────────────────────────────
    // Standard ERC-20 Transfer events cover mint/burn already.
    // These custom events add the rewardEventId so we can correlate
    // on-chain records back to off-chain reward events without parsing logs.
    event RewardMinted(address indexed user, uint256 amount, string rewardEventId);
    event RewardBurned(address indexed user, uint256 amount, string rewardEventId);

    // ─── Constructor ─────────────────────────────────────────────────────────
    constructor(address adminAddress) ERC20("ReFashion Token", "RFT") {
        // Grant all roles to the deployer-supplied admin address.
        // In production this will be a wallet controlled by our backend.
        _grantRole(DEFAULT_ADMIN_ROLE, adminAddress);
        _grantRole(MINTER_ROLE,        adminAddress);
        _grantRole(PAUSER_ROLE,        adminAddress);
    }

    // ─── Mint ────────────────────────────────────────────────────────────────
    /**
     * @param to            User's custodial wallet address
     * @param amount        Token amount in base units (multiply by 1e18 in the API)
     * @param rewardEventId Unique ID from the off-chain reward event table
     */
    function mint(
        address to,
        uint256 amount,
        string calldata rewardEventId
    ) external onlyRole(MINTER_ROLE) whenNotPaused {
        require(to != address(0), "RFT: mint to zero address");
        require(amount > 0,       "RFT: amount must be > 0");
        _mint(to, amount);
        emit RewardMinted(to, amount, rewardEventId);
    }

    // ─── Burn ────────────────────────────────────────────────────────────────
    /**
     * Burns from the user's wallet. The minter wallet pays gas; user doesn't need MATIC.
     *
     * @param from          User's custodial wallet address
     * @param amount        Token amount in base units
     * @param rewardEventId Unique ID from the off-chain reward event table
     */
    function burn(
        address from,
        uint256 amount,
        string calldata rewardEventId
    ) external onlyRole(MINTER_ROLE) whenNotPaused {
        require(from != address(0), "RFT: burn from zero address");
        require(amount > 0,         "RFT: amount must be > 0");
        require(balanceOf(from) >= amount, "RFT: insufficient balance");
        _burn(from, amount);
        emit RewardBurned(from, amount, rewardEventId);
    }

    // ─── Pause / Unpause ─────────────────────────────────────────────────────
    function pause()   external onlyRole(PAUSER_ROLE) { _pause(); }
    function unpause() external onlyRole(PAUSER_ROLE) { _unpause(); }

    // ─── Disable peer-to-peer transfers ──────────────────────────────────────
    // Users cannot transfer tokens. Only mint/burn is allowed.
    // This overrides the standard ERC-20 transfer functions.
    function transfer(address, uint256) public pure override returns (bool) {
        revert("RFT: transfers disabled");
    }

    function transferFrom(address, address, uint256) public pure override returns (bool) {
        revert("RFT: transfers disabled");
    }

    // ─── Required override (ERC20 + ERC20Pausable) ───────────────────────────
    function _update(
        address from,
        address to,
        uint256 value
    ) internal override(ERC20, ERC20Pausable) {
        super._update(from, to, value);
    }
}
