import { RegisterForm } from "@/components/molecules"
import { retrieveCustomer } from "@/lib/data/customer"
import { redirect } from "next/navigation"

export default async function Page() {
  const user = await retrieveCustomer()

  if (user) {
    redirect("/user")
  }
  return (
      <div className="py-10">
        <div className="mx-auto w-full max-w-xl md:max-w-2xl">
          <RegisterForm />
        </div>
      </div>
  )
}