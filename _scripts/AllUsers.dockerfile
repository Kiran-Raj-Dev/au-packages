FROM mcr.microsoft.com/windows:20H2
WORKDIR C:/app

ARG $INSTALLER_NAME
ARG $CHOCOLATEY_NUPKG

# Copy and run the installer
COPY $INSTALLER_NAME $INSTALLER_NAME
RUN $INSTALLER_NAME /quiet InstallAllUsers=1

# Install chocolatey
RUN @powershell Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Install Manim package
COPY $CHOCOLATEY_NUPKG $CHOCOLATEY_NUPKG