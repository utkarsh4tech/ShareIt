/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  swcMinify: true,
  async rewrites() {
    // Use an environment variable for the backend URL
    const backendUrl = process.env.NEXT_PUBLIC_API_URL || "http://localhost:8080";
    // Return an empty array if the backend URL is not set
    if (!backendUrl) {
      return [];
    }

    return [
      {
        source: '/api/:path*',
        destination: `${backendUrl}/:path*`, // Proxy to the backend service
      },
    ];
  },
}

module.exports = nextConfig

