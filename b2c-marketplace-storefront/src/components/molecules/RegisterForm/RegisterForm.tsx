"use client"

import {
  FieldError,
  FieldValues,
  FormProvider,
  useForm,
  useFormContext,
} from "react-hook-form"
import { useEffect, useMemo, useState } from "react"
import { zodResolver } from "@hookform/resolvers/zod"

import { Button } from "@/components/atoms"
import LocalizedClientLink from "@/components/molecules/LocalizedLink/LocalizedLink"
import { LabeledInput } from "@/components/cells"
import { registerFormSchema, RegisterFormData } from "./schema"
import { signup } from "@/lib/data/customer"

/** Inline, lightweight password validator (customize rules as needed) */
function PasswordValidator({
                             password,
                             setError,
                           }: {
  password?: string
  setError: (msg?: string) => void
}) {
  let msg: string | undefined
  if (!password || password.length < 8) {
    msg = "Password must be at least 8 characters."
  }
  useEffect(() => setError(msg), [msg, setError])
  return null
}

/** Dismissible error banner that auto-hides after 5s */
function ErrorBanner({
                       message,
                       onHide,
                     }: {
  message?: string
  onHide: () => void
}) {
  // start / reset 5s timer whenever message changes
  useEffect(() => {
    if (!message) return
    const t = setTimeout(onHide, 5000)
    return () => clearTimeout(t)
  }, [message, onHide])

  if (!message) return null

  return (
      <div
          role="alert"
          className="mt-4 rounded-md border border-red-300 bg-red-50 px-4 py-3 text-red-800"
      >
        <div className="flex items-start justify-between gap-3">
          <p className="label-md">{message}</p>
          <button
              type="button"
              aria-label="Dismiss"
              className="shrink-0 rounded p-1 hover:bg-red-100"
              onClick={onHide}
          >
            ×
          </button>
        </div>
      </div>
  )
}

export const RegisterForm = () => {
  const methods = useForm<RegisterFormData>({
    resolver: zodResolver(registerFormSchema),
    defaultValues: {
      firstName: "",
      lastName: "",
      phone: "",
      email: "",
      password: "",
      confirmPassword: "",
    },
  })

  return (
      <FormProvider {...methods}>
        <Form />
      </FormProvider>
  )
}

const Form = () => {
  const [error, setError] = useState<string | undefined>()
  const [passwordError, setPasswordError] = useState<string | undefined>()

  const {
    handleSubmit,
    register,
    watch,
    formState: { errors, isSubmitting },
  } = useFormContext<RegisterFormData>()

  const clearBanner = () => setError(undefined)

  const submit = async (data: FieldValues) => {
    // block submission if password validator has an active error
    if (passwordError) {
      setError(passwordError)
      return
    }

    const formData = new FormData()
    formData.append("email", data.email)
    formData.append("password", data.password)
    formData.append("first_name", data.firstName)
    formData.append("last_name", data.lastName)
    formData.append("phone", data.phone)

    const res = await signup(formData)

    if (res && !res?.id) {
      // normalize any response to a readable string
      const msg =
          (res as any)?.message ||
          (typeof res === "string" ? res : "Registration failed. Please try again.")
      setError(String(msg))
    } else {
      setError(undefined)
    }
  }

  // Optional: combine first validation error into banner automatically (keeps field errors too)
  const firstValidationError = useMemo(() => {
    const e = errors as Record<string, any>
    const key = Object.keys(e)[0]
    return key ? e[key]?.message : undefined
  }, [errors])

  useEffect(() => {
    if (firstValidationError) setError(String(firstValidationError))
  }, [firstValidationError])

  return (
      <main className="container">
        <h1 className="heading-xl text-center uppercase my-6">
          Join our community
        </h1>

        <form onSubmit={handleSubmit(submit)}>
          {/* Names */}
          <div className="flex flex-col md:flex-row gap-4 mb-4">
            <LabeledInput
                className="md:w-1/2"
                label="First name"
                placeholder="Your first name"
                {...register("firstName")}
            />
            <LabeledInput
                className="md:w-1/2"
                label="Last name"
                placeholder="Your last name"
                {...register("lastName")}
            />
          </div>

          {/* Email + Phone */}
          <div className="flex flex-col md:flex-row gap-4 mb-4">
            <LabeledInput
                className="md:w-1/2"
                label="E-mail"
                placeholder="Your e-mail address"
                {...register("email")}
            />
            <LabeledInput
                className="md:w-1/2"
                label="Phone"
                placeholder="Your phone number"
                {...register("phone")}
            />
          </div>

          {/* Password + validator */}
          <div>
            <LabeledInput
                className="mb-4"
                label="Password"
                placeholder="Your password"
                type="password"
                {...register("password")}
            />
            <PasswordValidator
                password={watch("password")}
                setError={setPasswordError}
            />
          </div>

          {/* Confirm password */}
          <LabeledInput
              className="mt-4"
              label="Confirm password"
              placeholder="Your password again"
              type="password"
              {...register("confirmPassword")}
          />

          <Button
              className="w-full flex justify-center mt-8 uppercase"
              disabled={isSubmitting}
              loading={isSubmitting}
          >
            Create account
          </Button>

          {/* Red warning banner below the button that hides after 5s */}
          <ErrorBanner message={error} onHide={clearBanner} />

          <p className="text-center label-md mt-4">
            Already have an account?{" "}
            <LocalizedClientLink href="/user" className="underline">
              Sign in!
            </LocalizedClientLink>
          </p>
        </form>
      </main>
  )
}
