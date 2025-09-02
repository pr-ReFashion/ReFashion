import { castRegistrationType } from "@mercurjs/framework/src/utils/cast" // import new helper

import { SellerDTO } from "@mercurjs/framework";

import jwt, { JwtPayload } from "jsonwebtoken";

import { ConfigModule } from "@medusajs/framework";
import { Context, CreateInviteDTO } from "@medusajs/framework/types";
import {
  InjectTransactionManager,
  MedusaContext,
  MedusaError,
  MedusaService,
} from "@medusajs/framework/utils";

import { SELLER_MODULE } from ".";
import { Member, MemberInvite, Seller, SellerOnboarding } from "./models";
import { MemberInviteDTO } from "@mercurjs/framework";

type InjectedDependencies = {
  configModule: ConfigModule;
};

type SellerModuleConfig = {
  validInviteDuration: number;
};

// 7 days
const DEFAULT_VALID_INVITE_DURATION = 60 * 60 * 24 * 7000;

class SellerModuleService extends MedusaService({
  MemberInvite,
  Member,
  Seller,
  SellerOnboarding,
}) {
  private readonly config_: SellerModuleConfig;
  private readonly httpConfig_: ConfigModule["projectConfig"]["http"];

  constructor({ configModule }: InjectedDependencies) {
    super(...arguments);

    this.httpConfig_ = configModule.projectConfig.http;

    const moduleDef = configModule.modules?.[SELLER_MODULE];

    const options =
      typeof moduleDef !== "boolean"
        ? (moduleDef?.options as SellerModuleConfig)
        : null;

    this.config_ = {
      validInviteDuration:
        options?.validInviteDuration ?? DEFAULT_VALID_INVITE_DURATION,
    };
  }

  async validateInviteToken(token: string) {
    const jwtSecret = this.httpConfig_.jwtSecret;
    const decoded: JwtPayload = jwt.verify(token, jwtSecret, {
      complete: true,
    });

    const invite = await this.retrieveMemberInvite(decoded.payload.id, {});

    if (invite.accepted) {
      throw new MedusaError(
        MedusaError.Types.INVALID_DATA,
        "The invite has already been accepted"
      );
    }

    if (invite.expires_at < new Date()) {
      throw new MedusaError(
        MedusaError.Types.INVALID_DATA,
        "The invite has expired"
      );
    }

    return invite;
  }

  @InjectTransactionManager()
  async addRewardPoints(
    sellerId: string,
    delta = 5,
    @MedusaContext() sharedContext: Context = {}
  ): Promise<number> {
    const seller = await this.retrieveSeller(sellerId, { select: ["id", "reward_points"] })

    const current = Number(seller.reward_points ?? 0)
    const next = current + delta

    await this.updateSellers({ id: sellerId, reward_points: next }, sharedContext)
    return next
  }

  // @ts-expect-error: createInvites method already exists
  async createMemberInvites(
    input: CreateInviteDTO | CreateInviteDTO[],
    @MedusaContext() sharedContext: Context = {}
  ): Promise<MemberInviteDTO[]> {
    const data = Array.isArray(input) ? input : [input];

    const expires_at = new Date();
    expires_at.setMilliseconds(
      new Date().getMilliseconds() + DEFAULT_VALID_INVITE_DURATION
    );

    const toCreate = data.map((invite) => ({
      ...invite,
      expires_at: new Date(),
      token: "placeholder",
    }));

    const created = await super.createMemberInvites(toCreate, sharedContext);
    const toUpdate = Array.isArray(created) ? created : [created];

    const updates = toUpdate.map((invite) => {
      const sanitizeSeller = (seller: any): Partial<SellerDTO> => {
        return {
          ...seller,
          registration_type: castRegistrationType(seller?.registration_type),
          members: undefined, // prevent circular recursion
        };
      };

      const sanitizedMembers = invite.seller?.members?.map((member) => ({
        ...member,
        seller: sanitizeSeller(member.seller),
      }));

      return {
        ...invite,
        id: invite.id,
        expires_at,
        token: this.generateToken({ id: invite.id }),
        seller: {
          ...sanitizeSeller(invite.seller),
          members: sanitizedMembers,
        },
      };
    });

    // @ts-ignore
    await this.updateMemberInvites(updates, sharedContext);

    return updates;
  }

  private generateToken(data: { id: string }): string {
    const jwtSecret = this.httpConfig_.jwtSecret as string;
    return jwt.sign(data, jwtSecret, {
      expiresIn: this.config_.validInviteDuration,
    });
  }

  async isOnboardingCompleted(seller_id: string): Promise<boolean> {
    const { onboarding } = await this.retrieveSeller(seller_id, {
      relations: ["onboarding"],
    });

    if (!onboarding) {
      return false;
    }

    return (
      onboarding.locations_shipping &&
      onboarding.products &&
      onboarding.store_information &&
      onboarding.stripe_connection
    );
  }
}

export default SellerModuleService;
