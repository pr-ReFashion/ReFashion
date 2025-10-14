// pages/vendor-debug.tsx (Next.js)
// Server-side read via getServerSideProps
import React from "react";

export const getServerSideProps = async ({ req }) => {
    const raw = req.headers.cookie || "";
    // raw contains cookies the browser sent to your server (includes HttpOnly)
    return { props: { raw } };
}

export default function VendorDebugPage({ raw }: { raw: string }) {
    return (
        <div style={{ padding: 12 }}>
            <h3>Cookies received by server</h3>
            <pre>{raw || "<no cookies in request>"}</pre>
            <p>Note: server sees HttpOnly cookies that client JS cannot.</p>
        </div>
    );
}
