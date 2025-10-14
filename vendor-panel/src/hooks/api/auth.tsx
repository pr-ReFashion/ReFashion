import { FetchError } from "@medusajs/js-sdk"
import { HttpTypes } from "@medusajs/types"
import { UseMutationOptions, useMutation } from "@tanstack/react-query"
import { fetchQuery, sdk } from "../../lib/client"

/** Append ".refashion" to an email unless it already ends with it (case-insensitive). */
const ensureRefashionEmail = (input?: string) => {
  const clean = (input ?? "").trim()
  if (!clean) return clean
  return clean.toLowerCase().endsWith(".refashion") ? clean : `${clean}.refashion`
}

export const useSignInWithEmailPass = (
    options?: UseMutationOptions<
        | string
        | {
      location: string
    },
        FetchError,
        HttpTypes.AdminSignUpWithEmailPassword
    >
) => {
  return useMutation({
    mutationFn: (payload) => {
      const adjusted = {
        ...payload,
        ...(payload?.email ? { email: ensureRefashionEmail(payload.email) } : {}),
      }
      return sdk.auth.login("seller", "emailpass", adjusted)
    },
    onSuccess: async (data, variables, context) => {
      options?.onSuccess?.(data, variables, context)
    },
    ...options,
  })
}

export const useSignUpWithEmailPass = (
    options?: UseMutationOptions<
        string,
        FetchError,
        HttpTypes.AdminSignInWithEmailPassword & {
      confirmPassword: string
      name: string
    }
    >
) => {
  return useMutation({
    mutationFn: (payload) => {
      const adjusted = {
        ...payload,
        ...(payload?.email ? { email: ensureRefashionEmail(payload.email) } : {}),
      }
      return sdk.auth.register("seller", "emailpass", adjusted)
    },
    onSuccess: async (_, variables) => {
      // Keep the seller/member contact email as originally typed (no suffix),
      // since the suffix is only needed for the auth provider identity.
      const seller = {
        name: variables.name,
        member: {
          name: variables.name,
          email: variables.email,
        },
      }
      await fetchQuery("/vendor/sellers", {
        method: "POST",
        body: seller,
      })
    },
    ...options,
  })
}

export const useResetPasswordForEmailPass = (
    options?: UseMutationOptions<void, FetchError, { email: string }>
) => {
  return useMutation({
    mutationFn: (payload) =>
        sdk.auth.resetPassword("seller", "emailpass", {
          identifier: ensureRefashionEmail(payload.email) as string,
        }),
    onSuccess: async (data, variables, context) => {
      options?.onSuccess?.(data, variables, context)
    },
    ...options,
  })
}

export const useLogout = (options?: UseMutationOptions<void, FetchError>) => {
  return useMutation({
    mutationFn: () => sdk.auth.logout(),
    ...options,
  })
}

export const useUpdateProviderForEmailPass = (
    token: string,
    options?: UseMutationOptions<void, FetchError, { password: string }>
) => {
  return useMutation({
    mutationFn: (payload) =>
        sdk.auth.updateProvider("seller", "emailpass", payload, token),
    onSuccess: async (data, variables, context) => {
      options?.onSuccess?.(data, variables, context)
    },
    ...options,
  })
}
