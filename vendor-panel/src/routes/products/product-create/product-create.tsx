import { useTranslation } from "react-i18next"
import { RouteFocusModal } from "../../../components/modals"
import { useMe, useSalesChannels } from "../../../hooks/api"
import { useStore } from "../../../hooks/api/store"
import { ProductCreateForm } from "./components/product-create-form/product-create-form"
import { ProductCreateError } from "./components/product-create-form/product-create-error"



export const ProductCreate = () => {
  const { t } = useTranslation()

  const { store, isPending: isStorePending } = useStore()

  const { sales_channels, isPending: isSalesChannelPending } =
    useSalesChannels()

  const seller = useMe()?.seller

/**
*  A seller to sell must set the store address
*  The address must include the address_line, postal_code,country_code,city
*/
    const hasAddress =
    !!seller &&
    [seller.address_line, seller.postal_code, seller.country_code, seller.city]
      .every(v => typeof v === "string" ? v.trim().length > 0 : Boolean(v))


  const ready =
    !!store && !isStorePending && !!sales_channels && !isSalesChannelPending
  return (


  <RouteFocusModal>
      <RouteFocusModal.Title asChild>
        <span className="sr-only">{t("products.create.title")}</span>
      </RouteFocusModal.Title>
      <RouteFocusModal.Description asChild>
        <span className="sr-only">{t("products.create.description")}</span>
      </RouteFocusModal.Description>
      {!hasAddress? (
      <ProductCreateError
        primaryLabel={t("products.create.go_to_locations", "Go to Settings")}
        onPrimaryClick={() => { window.location.href = "/settings/store/edit-company" }}
      />
    ) : ready ? (

      <ProductCreateForm defaultChannel={sales_channels[0]} store={store!} />
    ) : null}
    </RouteFocusModal>
  )
}
