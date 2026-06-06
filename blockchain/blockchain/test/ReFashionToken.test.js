const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("ReFashionToken", function () {
  let token, admin, minter, user, stranger;

  beforeEach(async () => {
    [admin, minter, user, stranger] = await ethers.getSigners();
    const ReFashionToken = await ethers.getContractFactory("ReFashionToken");
    token = await ReFashionToken.deploy(admin.address);
    await token.waitForDeployment();
  });

  // ── Deployment ─────────────────────────────────────────────────────────
  describe("Deployment", () => {
    it("sets correct name and symbol", async () => {
      expect(await token.name()).to.equal("ReFashion Token");
      expect(await token.symbol()).to.equal("RFT");
    });

    it("grants all roles to admin", async () => {
      const MINTER_ROLE = await token.MINTER_ROLE();
      const PAUSER_ROLE = await token.PAUSER_ROLE();
      expect(await token.hasRole(MINTER_ROLE, admin.address)).to.be.true;
      expect(await token.hasRole(PAUSER_ROLE, admin.address)).to.be.true;
    });
  });

  // ── Minting ────────────────────────────────────────────────────────────
  describe("Mint", () => {
    it("mints tokens to a user", async () => {
      const amount = ethers.parseEther("50");
      await token.connect(admin).mint(user.address, amount, "evt-001");
      expect(await token.balanceOf(user.address)).to.equal(amount);
    });

    it("emits RewardMinted event", async () => {
      const amount = ethers.parseEther("10");
      await expect(token.connect(admin).mint(user.address, amount, "evt-002"))
        .to.emit(token, "RewardMinted")
        .withArgs(user.address, amount, "evt-002");
    });

    it("reverts if caller lacks MINTER_ROLE", async () => {
      await expect(
        token.connect(stranger).mint(user.address, ethers.parseEther("10"), "evt-003")
      ).to.be.reverted;
    });

    it("reverts on zero amount", async () => {
      await expect(
        token.connect(admin).mint(user.address, 0, "evt-004")
      ).to.be.revertedWith("RFT: amount must be > 0");
    });
  });

  // ── Burning ────────────────────────────────────────────────────────────
  describe("Burn", () => {
    beforeEach(async () => {
      await token.connect(admin).mint(user.address, ethers.parseEther("100"), "setup");
    });

    it("burns tokens from a user", async () => {
      await token.connect(admin).burn(user.address, ethers.parseEther("40"), "burn-001");
      expect(await token.balanceOf(user.address)).to.equal(ethers.parseEther("60"));
    });

    it("emits RewardBurned event", async () => {
      const amount = ethers.parseEther("20");
      await expect(token.connect(admin).burn(user.address, amount, "burn-002"))
        .to.emit(token, "RewardBurned")
        .withArgs(user.address, amount, "burn-002");
    });

    it("reverts on insufficient balance", async () => {
      await expect(
        token.connect(admin).burn(user.address, ethers.parseEther("200"), "burn-003")
      ).to.be.revertedWith("RFT: insufficient balance");
    });
  });

  // ── Transfers disabled ─────────────────────────────────────────────────
  describe("Transfers", () => {
    it("reverts on transfer()", async () => {
      await token.connect(admin).mint(user.address, ethers.parseEther("10"), "t-001");
      await expect(
        token.connect(user).transfer(stranger.address, ethers.parseEther("5"))
      ).to.be.revertedWith("RFT: transfers disabled");
    });

    it("reverts on transferFrom()", async () => {
      await token.connect(admin).mint(user.address, ethers.parseEther("10"), "t-002");
      await expect(
        token.connect(user).transferFrom(user.address, stranger.address, ethers.parseEther("5"))
      ).to.be.revertedWith("RFT: transfers disabled");
    });
  });

  // ── Pause ──────────────────────────────────────────────────────────────
  describe("Pause", () => {
    it("pauses minting", async () => {
      await token.connect(admin).pause();
      await expect(
        token.connect(admin).mint(user.address, ethers.parseEther("10"), "p-001")
      ).to.be.revertedWithCustomError(token, "EnforcedPause");
    });

    it("unpauses and allows minting again", async () => {
      await token.connect(admin).pause();
      await token.connect(admin).unpause();
      await token.connect(admin).mint(user.address, ethers.parseEther("10"), "p-002");
      expect(await token.balanceOf(user.address)).to.equal(ethers.parseEther("10"));
    });
  });

  // ── Role management ────────────────────────────────────────────────────
  describe("Role management", () => {
    it("admin can grant MINTER_ROLE to another wallet", async () => {
      const MINTER_ROLE = await token.MINTER_ROLE();
      await token.connect(admin).grantRole(MINTER_ROLE, minter.address);
      await token.connect(minter).mint(user.address, ethers.parseEther("5"), "r-001");
      expect(await token.balanceOf(user.address)).to.equal(ethers.parseEther("5"));
    });

    it("admin can revoke MINTER_ROLE", async () => {
      const MINTER_ROLE = await token.MINTER_ROLE();
      await token.connect(admin).grantRole(MINTER_ROLE, minter.address);
      await token.connect(admin).revokeRole(MINTER_ROLE, minter.address);
      await expect(
        token.connect(minter).mint(user.address, ethers.parseEther("5"), "r-002")
      ).to.be.reverted;
    });
  });
});
