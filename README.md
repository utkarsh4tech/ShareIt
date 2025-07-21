# ShareIt - Simple Peer-to-Peer File Sharing

**ShareIt** is a lightweight utility for sharing files directly between two computers on the same network. It provides a simple web interface for uploading a file, which then becomes available for direct download by another user via a unique link.

The core principle is peer-to-peer sharing. When you upload a file, it starts a temporary web server on your machine that serves only that specific file. The other user downloads the file directly from your computer, with no intermediary cloud storage involved.

## How It Works: Implementation Details

The project is built with a standard Java backend and a modern Next.js frontend, designed to be run locally for straightforward file transfers.

### Backend

The backend is a lightweight, self-contained Java application built with **Maven**. It does not use a large framework like Spring Boot, relying instead on Java's built-in `HttpServer` for a minimal footprint.

1.  **API Server**: When the application starts (via `in.utkarsh4tech.App`), it launches a primary API server on port **8080**. This server listens for two main commands:
    * `POST /upload`: This endpoint is responsible for handling file uploads. It uses the **Apache Commons FileUpload** library to correctly parse the `multipart/form-data` stream from the web frontend.
    * `GET /download/{port}`: This endpoint facilitates the download process (though the actual file transfer is handled by the peer-to-peer server).

2.  **File Storage**: Uploaded files are temporarily stored in the system's temporary directory (e.g., `/tmp` or `%TEMP%`) in a dedicated folder named `ShareIt-uploads`. Each filename is given a unique UUID to prevent conflicts.

3.  **Peer-to-Peer Server (`FileSharer`)**: This is the core of the sharing mechanism.
    * When a file is successfully uploaded, the `FileSharer` service is called.
    * It finds a random, available network port on the host machine.
    * It then launches a **new, temporary `HttpServer`** on that random port. This new server's only job is to serve the single file that was just uploaded.
    * The backend then sends a JSON response back to the frontend, containing the unique port number for the new file server (e.g., `{"port": 54321}`).

### Frontend

The frontend is a **Next.js** application that provides a clean, simple user interface for the file upload process.

1.  **User Interface**: A single page allows the user to select a file from their computer and click an "Upload" button.
2.  **API Communication**: When the user uploads a file, the frontend makes a `POST` request to the backend's `/upload` endpoint.
3.  **Dynamic Links**: After a successful upload, the frontend receives the unique port number from the backend. It then constructs a download link for the user to share, in the format `http://<your-local-ip>:<port>`.

### The Complete Flow

1.  User runs `start.sh`. The script builds the Java project and starts the backend server on port 8080. It then starts the Next.js frontend on port 3000.
2.  User opens `http://localhost:3000` in their browser.
3.  User selects a file and clicks "Upload".
4.  The frontend sends the file to the backend at `http://localhost:8080/upload`.
5.  The backend saves the file and starts a new, temporary server on a random port (e.g., 55123).
6.  The backend responds with `{"port": 55123}`.
7.  The frontend displays a success message and a shareable download link like `http://192.168.1.5:55123` (using the user's local IP).
8.  Another user on the same network opens this link and downloads the file directly from the first user's computer.
