PKG_NAME="XONE"
PKG_VERSION="819a265920e2624600ccadbb0ebc57168dec12a5"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/medusalix/xone"
PKG_URL="https://github.com/medusalix/xone/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain linux"
PKG_NEED_UNPACK="$LINUX_DEPENDS"
PKG_LONGDESC="XONE Linux driver"
PKG_IS_KERNEL_PKG="yes"
PKG_TOOLCHAIN="make"

make_target() {
  kernel_make -C $(kernel_path) M=${PKG_BUILD}/ modules
}

makeinstall_target() {
  mkdir -p ${INSTALL}/$(get_full_module_dir)/kernel/drivers/hid
   cp -rv ${PKG_BUILD}/*.ko ${INSTALL}/$(get_full_module_dir)/kernel/drivers/hid

  # Install modprobe.d config files
  cp -PRv ${PKG_DIR}/config/* ${INSTALL}

  # Firmware download
  driver_url='http://download.windowsupdate.com/c/msdownload/update/driver/drvs/2017/07/1cd6a87c-623f-4407-a52d-c31be49e925c_e19f60808bdcbfbd3c3df6be3e71ffc52e43261e.cab'
  firmware_hash='48084d9fa53b9bb04358f3bb127b7495dc8f7bb0b3ca1437bd24ef2b6eabdf66'
  
  PKG_FW_DIR="${INSTALL}/$(get_kernel_overlay_dir)/lib/firmware"
  mkdir -p "${PKG_FW_DIR}"
  
  curl -L -o driver.cab "$driver_url"
  cabextract -F FW_ACC_00U.bin driver.cab
  echo "$firmware_hash" FW_ACC_00U.bin | sha256sum -c
  mv FW_ACC_00U.bin ${PKG_FW_DIR}/xow_dongle.bin
  rm driver.cab
}
