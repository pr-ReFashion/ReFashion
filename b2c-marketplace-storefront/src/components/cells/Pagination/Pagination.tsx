'use client';
import { PaginationButton } from '@/components/atoms';
import { CollapseIcon, MeatballsMenuIcon } from '@/icons';

type Props = {
    pages: number;
    setPage: (page: number) => void;
    currentPage: number;
};

function buildItems(total: number, current: number): (number | '…')[] {
    if (total <= 5) {
        return Array.from({ length: total }, (_, i) => i + 1);
    }

    // Always include 1 and 2
    const items: (number | '…')[] = [1, 2];

    // Near the start: show 3, 4, then ellipsis, then last
    if (current <= 4) {
        items.push(3, 4, '…', total);
        return items;
    }

    // Near the end: show ellipsis, then last 4 pages
    if (current >= total - 3) {
        items.push('…', total - 3, total - 2, total - 1, total);
        // Remove duplicate 2 if total-3 === 2 (when total == 5 handled above)
        return Array.from(new Set(items));
    }

    // Middle: show ellipsis, neighbors, ellipsis, last
    items.push('…', current - 1, current, current + 1, '…', total);

    // De-dup in rare overlaps
    return items.filter((v, i, a) => a.indexOf(v) === i);
}

export const Pagination = ({ pages, setPage, currentPage }: Props) => {
    const items = buildItems(pages, currentPage);

    const renderItem = (it: number | '…') => {
        if (it === '…') {
            return (
                <PaginationButton key={`dots-${Math.random()}`} disabled>
                    <MeatballsMenuIcon />
                </PaginationButton>
            );
        }

        const isActive = it === currentPage;
        return (
            <PaginationButton
                key={`p-${it}`}
                isActive={isActive}
                onClick={!isActive ? () => setPage(it) : undefined}
            >
                {it}
            </PaginationButton>
        );
    };

    return (
        <div className="flex items-center">
            {/* Prev */}
            <PaginationButton
                disabled={currentPage === 1}
                onClick={() => setPage(currentPage - 1)}
                className="border-none"
            >
                <CollapseIcon size={20} className="rotate-90" />
            </PaginationButton>

            {/* Page numbers + ellipses */}
            {items.map(renderItem)}

            {/* Next */}
            <PaginationButton
                disabled={currentPage === pages}
                onClick={() => setPage(currentPage + 1)}
                className="border-none"
            >
                <CollapseIcon size={20} className="-rotate-90" />
            </PaginationButton>
        </div>
    );
};
