'use client';
import { Pagination } from '@/components/cells';
import { usePagination } from '@/hooks/usePagination';

export const ProductsPagination = ({ pages }: { pages: number }) => {
    const { currentPage, setPage } = usePagination(12); // pass your PRODUCT_LIMIT if you like

    return (
        <div className="mt-6 flex justify-center">
            <Pagination
                pages={pages}
                currentPage={currentPage}
                setPage={(p: number) => setPage(p)}
            />
        </div>
    )
}
