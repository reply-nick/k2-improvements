#!/bin/ash
set -e

SCRIPT_DIR=$(readlink -f $(dirname ${0}))

test -d ~/printer_data/config/custom || mkdir -p ~/printer_data/config/custom

# add the main.cfg to printer.cfg
python ${SCRIPT_DIR}/../../../scripts/ensure_included.py \
    ~/printer_data/config/printer.cfg custom/main.cfg

test -f ~/printer_data/config/custom/main.cfg || touch ~/printer_data/config/custom/main.cfg

# this file is intended to be user modified
cp -f ${SCRIPT_DIR}/overrides.cfg ~/printer_data/config/custom/overrides.cfg

if ! grep -qE 'include overrides.cfg' ~/printer_data/config/custom/main.cfg; then
    echo '[include overrides.cfg]' >> ~/printer_data/config/custom/main.cfg
fi

/etc/init.d/klipper restart
