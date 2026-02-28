# Use the official Nginx unprivileged Alpine image
FROM nginxinc/nginx-unprivileged:alpine

# Temporarily switch to root to remove the mutating entrypoint script
USER root

# Remove all default startup scripts since our config is fully baked in
RUN rm /docker-entrypoint.d/*.sh

# Switch back to the unprivileged nginx user (UID 101 in this image)
USER 101

# Overwrite default files directly and ensure nginx owns them
COPY --chown=nginx:nginx ./index.html /usr/share/nginx/html/
COPY --chown=nginx:nginx ./gallery.html /usr/share/nginx/html/
COPY --chown=nginx:nginx ./prices.html /usr/share/nginx/html/
COPY --chown=nginx:nginx ./contact.html /usr/share/nginx/html/
COPY --chown=nginx:nginx ./impress.html /usr/share/nginx/html/
COPY --chown=nginx:nginx ./location.html /usr/share/nginx/html/
COPY --chown=nginx:nginx ./rooms.html /usr/share/nginx/html/
COPY --chown=nginx:nginx ./assets /usr/share/nginx/html/assets/

# Copy custom Nginx configuration and security headers
COPY ./nginx/nginx.conf /etc/nginx/conf.d/default.conf
COPY ./nginx/security-headers.conf /etc/nginx/conf.d/security-headers.conf

# Expose port 8080 (the unprivileged Nginx default)
EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]