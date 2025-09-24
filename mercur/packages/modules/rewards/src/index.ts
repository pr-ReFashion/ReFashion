import { Module } from "@medusajs/framework/utils"
import RewardsModuleService from "./service"

export const REWARDS_MODULE = "rewardsModuleService"

export default Module(REWARDS_MODULE, {
  service: RewardsModuleService,
})
