{ pkgs, ... }: {
  # DaVinci Resolve with Intel Arc (Lunar Lake) GPU support
  # Requires OpenCL runtime for GPU acceleration

  environment.systemPackages = with pkgs; [
    # DaVinci Resolve (free version)
    # Use davinci-resolve-studio for the paid Studio version
    davinci-resolve

    # OpenCL ICD loader - discovers and loads OpenCL implementations
    ocl-icd

    # Useful tools for debugging GPU/OpenCL issues
    clinfo  # OpenCL info tool

    # FFmpeg for video conversion (MP4 to DNxHD/ProRes for better Resolve compatibility)
    ffmpeg-full
  ];

  # Hardware OpenCL support for Intel GPUs
  hardware.graphics.extraPackages = with pkgs; [
    # Intel OpenCL runtime (Neo) - required for DaVinci Resolve GPU acceleration
    intel-compute-runtime

    # OpenCL ICD loader
    ocl-icd
  ];

  # Environment variables for DaVinci Resolve with Intel Arc
  environment.sessionVariables = {
    # Ensure OpenCL finds Intel GPU
    OCL_ICD_VENDORS = "/run/opengl-driver/etc/OpenCL/vendors";

    # Force DaVinci Resolve to use OpenCL (Intel Arc doesn't support CUDA)
    # This helps with compatibility on Intel GPUs
    RESOLVE_DISABLE_CUDA = "1";

    # Qt scaling for HiDPI displays - adjust value as needed (1.5, 2, etc.)
    QT_SCALE_FACTOR = "1.5";
  };
}
