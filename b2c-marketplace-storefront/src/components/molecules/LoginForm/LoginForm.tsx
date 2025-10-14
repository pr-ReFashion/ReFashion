"use client"
import React, { useState } from "react"
import {
  FieldError,
  FieldValues,
  FormProvider,
  useForm,
  useFormContext,
} from "react-hook-form"
import { zodResolver } from "@hookform/resolvers/zod"
import { loginFormSchema, LoginFormData } from "./schema"
import { Button } from "@/components/atoms"
import LocalizedClientLink from "@/components/molecules/LocalizedLink/LocalizedLink"
import { LabeledInput } from "@/components/cells"
import { login } from "@/lib/data/customer"
import { useRouter } from "next/navigation"

type LoginResult =
    | { ok: true; vendorToken: string | null }
    | { ok: false; error: string }
    | string // backward-compat

export const LoginForm = () => {
  const methods = useForm<LoginFormData>({
    resolver: zodResolver(loginFormSchema),
    defaultValues: { email: "", password: "" },
  })

  return (
      <FormProvider {...methods}>
        <Form />
      </FormProvider>
  )
}

const Form = () => {
  const [error, setError] = useState("")
  const {
    handleSubmit,
    register,
    formState: { errors, isSubmitting },
  } = useFormContext<LoginFormData>()
  const router = useRouter()

  const submit = async (data: FieldValues) => {
    setError("")

    const formData = new FormData()
    formData.append("email", String(data.email || ""))
    formData.append("password", String(data.password || ""))

    const res = (await login(formData)) as LoginResult


    // string error (legacy)
    if (typeof res === "string") {
      if (res) setError(res)
      return
    }

    if (!res?.ok) {
      setError(res?.error || "Login failed")
      return
    }

    // ✅ stash the vendor token for later (SellNowButton or other UI)
    try {
      if (res.vendorToken) {
        localStorage.setItem("medusa_vendor_token", res.vendorToken)
      } else {
        localStorage.removeItem("medusa_vendor_token")
      }
    } catch {}

    // If you want to jump straight to vendor panel instead, uncomment:
    // if (res.vendorToken) {
    //   window.location.assign(
    //     `http://localhost:5173/auth/accept?token=${encodeURIComponent(res.vendorToken)}`
    //   )
    //   return
    // }

    // Proceed to customer area
    router.push("/user")
  }

  return (
      <main className="container">
        <h1 className="heading-xl text-center uppercase my-6">
          Log in to your account
        </h1>

        <form onSubmit={handleSubmit(submit)}>
          <div className="w-96 max-w-full mx-auto space-y-4">
            <LabeledInput
                label="E-mail"
                placeholder="Your e-mail address"
                error={errors.email as FieldError}
                {...register("email")}
            />
            <LabeledInput
                label="Password"
                placeholder="Your password"
                type="password"
                error={errors.password as FieldError}
                {...register("password")}
            />

            {error && <p className="label-md text-negative">{error}</p>}

            <Button className="w-full" disabled={isSubmitting}>
              {isSubmitting ? "Signing in..." : "Log in"}
            </Button>

            <p className="text-center label-md">
              Don&apos;t have an account yet?{" "}
              <LocalizedClientLink href="/user/register" className="underline">
                Sign up!
              </LocalizedClientLink>
            </p>
          </div>
        </form>
      </main>
  )
}
