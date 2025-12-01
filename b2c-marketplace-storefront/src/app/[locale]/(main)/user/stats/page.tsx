import { LoginForm } from "@/components/molecules"
import { UserNavigation } from "@/components/molecules"
import { retrieveCustomer } from "@/lib/data/customer"
import { StatsTabs } from "@/components/molecules/user/stats-tabs" //

export default async function UserStatsPage() {
    const user = await retrieveCustomer()

    if (!user) return <LoginForm />

    return (
        <main className="container">
            <div className="grid grid-cols-1 md:grid-cols-4 mt-6 gap-5 md:gap-8">
                {/* Left menu */}
                <UserNavigation />

                {/* Right content */}
                <div className="md:col-span-3">
                    <h1 className="heading-xl uppercase mb-4">Stats</h1>

                    {/* Tabs */}
                    <StatsTabs />
                </div>
            </div>
        </main>
    )
}
