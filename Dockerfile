FROM nginx:alpine

# Copy nginx gateway configuration
COPY nginx/gateway.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
