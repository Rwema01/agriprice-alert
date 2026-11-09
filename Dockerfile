# Stage 1: Builder
FROM python:3.11-alpine AS builder

WORKDIR /app

# Install build dependencies needed for alpine
RUN apk add --no-cache gcc musl-dev linux-headers

# Install dependencies into a local folder
COPY requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt && \
    pip install --no-cache-dir --user --upgrade jaraco.context wheel

# Stage 2: Runtime
FROM python:3.11-alpine

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Create a non-root user
RUN adduser -D myuser

WORKDIR /app

# Copy the installed dependencies from the builder stage
COPY --from=builder /root/.local /home/myuser/.local

# Copy the application code
COPY . .

# Change ownership to the non-root user
RUN chown -R myuser:myuser /app

# Switch to the non-root user
USER myuser

# Ensure the local bin is in the PATH for the new user
ENV PATH=/home/myuser/.local/bin:$PATH

# Expose the port
EXPOSE 5000

# Add Healthcheck (Required for F3)
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
  CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:5000/health')" || exit 1

# Use Gunicorn for production instead of the Flask dev server
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]