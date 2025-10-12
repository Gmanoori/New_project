# Use Python as the base image since the main application is Python-based
FROM python:3.9-slim

# Install system dependencies including zip for backup functionality
RUN apt-get update && apt-get install -y \
    zip \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory in the container
WORKDIR /app

# Copy the project files
COPY . .

# Create necessary directories
RUN mkdir -p backup

# Make shell scripts executable
RUN chmod +x scripts/backup_step3.sh

# # Create a wrapper script to handle input properly
# RUN echo -e '#!/bin/bash\ncd /app\nexec ./scripts/backup_step3.sh "$@"' > /app/entrypoint.sh && \
#     chmod +x /app/entrypoint.sh

# # Set the entry point to use shell form for proper stdin handling
# ENTRYPOINT ["/bin/bash", "/app/entrypoint.sh"]

# # Default command arguments (can be overridden)
# CMD ["test", "zip"]

# Change directory to scripts
WORKDIR /app/scripts


CMD ["/bin/bash"]