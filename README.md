# API Health Check and Service Restart Script

This project provides a script for monitoring the health of various web services and automatically restarting them if they become unresponsive. It's designed to be easy to configure and deploy on any system running systemd.

## Features

- **Health Checks**: Regularly checks the health of configured web services.
- **Automatic Service Restart**: Automatically restarts services if their health check fails.
- **Log Rotation**: Implements a basic log rotation mechanism to prevent log files from growing indefinitely.
- **Configurable**: All services are defined in a separate JSON configuration file for easy management.
- **Error Handling**: Robust error handling to manage different failure scenarios.
- **Service Restart Policy**: Limits the number of restart attempts and adds delay between attempts.

## Getting Started

### Prerequisites

- A Unix-like operating system with systemd
- `curl` and `jq` installed on your system
- Sudo privileges (for restarting services and creating log files)

### Installation

1. Clone the repository:

   ```sh
   git clone [your-repo-url]

2. Navigate to the script directory: 
    ```sh
    cd [your-directory]

3. Make the script executable:
    ```sh 
    chmod +x check_apis.sh

4. Update the `services_config.json` with your service names and health check URLs.

### Usage

Run the script manually:

    ```sh 
    ./check_apis.sh

Or set it up as a cron job to run automatically at your desired frequency.

### Configuring the Cron Job

Edit your crontab:

    ```sh 
    crontab -e


Add a line like the following to run the script every 2 minutes:

    ```sh 
    */2 * * * * /path/to/check_apis.sh



## Configuration

The services_config.json` file should be structured as follows:

    ```json
        {
        "service_name1": "health-check-url-1",
        "service_name2": "health-check-url-2"
        }


Replace service1, service2, etc., with your service names, and health-check-url-1, health-check-url-2 with the corresponding health check URLs.


##Logs
Logs are stored in log directory. Log files are rotated based on size, as defined in the script.

##Contributing
Contributions are welcome! Feel free to open issues or submit pull requests.


