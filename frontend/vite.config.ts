import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import path from 'path'
import { fileURLToPath } from 'node:url'

const configDirectory = path.dirname(fileURLToPath(import.meta.url))

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [react()],
  resolve: {
    alias: {
      '@': path.resolve(configDirectory, './src'),
      '@components': path.resolve(configDirectory, './src/components'),
      '@pages': path.resolve(configDirectory, './src/pages'),
      '@services': path.resolve(configDirectory, './src/services'),
    },
  },
  server: {
    host: '0.0.0.0',
    port: 5173,
    strictPort: true,
    watch: {
      usePolling: true,
      interval: 1000,
    },
    // Allows the Docker Compose internal hostname through when tests hit
    // the stack via NGINX (e.g. BASE_URL=https://videortc-nginx).
    allowedHosts: [
      'localhost',
      'videocall.local',
      'videortc-nginx',
      'host.docker.internal',
      'videortc.test',
    ],
    hmr: {
      clientPort: 443,
      protocol: 'wss',
    },
  },
  preview: {
    host: '0.0.0.0',
    port: 5173,
  },
})
