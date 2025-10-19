import { Button } from "@medusajs/ui"
import { useTranslation } from "react-i18next"
import { RouteFocusModal } from "../../../../../components/modals"

type ProductCreateErrorProps = {
  title?: string
  description?: string
  primaryLabel?: string
  onPrimaryClick?: () => void
}

export const ProductCreateError = ({
  title,
  description,
  primaryLabel,
  onPrimaryClick,
}: ProductCreateErrorProps) => {
  const { t } = useTranslation()

  return (
    <>
      <RouteFocusModal.Body>
        <div
          role="alert"
          className="m-4 rounded-md border border-red-300 bg-red-50 p-4 text-red-700"
        >
          <p className="font-medium">
            {title ??
              t(
                "products.create.missing_location_title",
                "No default Address set"
              )}
          </p>
          <p className="mt-1 text-sm">
            {description ??
              t(
                "products.create.missing_location_desc",
                "Please set a default address for your store before creating a product."
              )}
          </p>
        </div>
      </RouteFocusModal.Body>

      <RouteFocusModal.Footer>
        <div className="flex items-center justify-end gap-x-2">
          <RouteFocusModal.Close asChild>
            <Button variant="secondary" size="small">
              {t("actions.close", "Close")}
            </Button>
          </RouteFocusModal.Close>

          {onPrimaryClick && (
            <Button
              size="small"
              variant="primary"
              onClick={onPrimaryClick}
            >
              {primaryLabel ?? t("actions.go_to_settings", "Go to Settings")}
            </Button>
          )}
        </div>
      </RouteFocusModal.Footer>
    </>
  )
}
