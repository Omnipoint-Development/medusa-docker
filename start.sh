#!/bin/sh

# Run database migrations
npx medusa migrations run

# Start the Medusa development server
npm run start
