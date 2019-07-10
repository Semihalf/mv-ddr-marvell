#!/bin/sh
#*******************************************************************************
# Copyright (C) 2017 Marvell International Ltd.
#
# This software file (the "File") is owned and distributed by Marvell
# International Ltd. and/or its affiliates ("Marvell") under the following
# alternative licensing terms.  Once you have made an election to distribute the
# File under one of the following license alternatives, please (i) delete this
# introductory statement regarding license alternatives, (ii) delete the three
# license alternatives that you have not elected to use and (iii) preserve the
# Marvell copyright notice above.
#
#********************************************************************************
# Marvell Commercial License Option
#
# If you received this File from Marvell and you have entered into a commercial
# license agreement (a "Commercial License") with Marvell, the File is licensed
# to you under the terms of the applicable Commercial License.
#
#********************************************************************************
# Marvell GPL License Option
#
# This program is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free
# Software Foundation, either version 2 of the License, or any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#********************************************************************************
# Marvell GNU General Public License FreeRTOS Exception
#
# If you received this File from Marvell, you may opt to use, redistribute and/or
# modify this File in accordance with the terms and conditions of the Lesser
# General Public License Version 2.1 plus the following FreeRTOS exception.
# An independent module is a module which is not derived from or based on
# FreeRTOS.
# Clause 1:
# Linking FreeRTOS statically or dynamically with other modules is making a
# combined work based on FreeRTOS. Thus, the terms and conditions of the GNU
# General Public License cover the whole combination.
# As a special exception, the copyright holder of FreeRTOS gives you permission
# to link FreeRTOS with independent modules that communicate with FreeRTOS solely
# through the FreeRTOS API interface, regardless of the license terms of these
# independent modules, and to copy and distribute the resulting combined work
# under terms of your choice, provided that:
# 1. Every copy of the combined work is accompanied by a written statement that
# details to the recipient the version of FreeRTOS used and an offer by yourself
# to provide the FreeRTOS source code (including any modifications you may have
# made) should the recipient request it.
# 2. The combined work is not itself an RTOS, scheduler, kernel or related
# product.
# 3. The independent modules add significant and primary functionality to
# FreeRTOS and do not merely extend the existing functionality already present in
# FreeRTOS.
# Clause 2:
# FreeRTOS may not be used for any competitive or comparative purpose, including
# the publication of any form of run time or compile time metric, without the
# express permission of Real Time Engineers Ltd. (this is the norm within the
# industry and is intended to ensure information accuracy).
#
#********************************************************************************
# Marvell BSD License Option
#
# If you received this File from Marvell, you may opt to use, redistribute and/or
# modify this File under the following licensing terms.
# Redistribution and use in source and binary forms, with or without modification,
# are permitted provided that the following conditions are met:
#
#      * Redistributions of source code must retain the above copyright notice,
#        this list of conditions and the following disclaimer.
#
#      * Redistributions in binary form must reproduce the above copyright
#        notice, this list of conditions and the following disclaimer in the
#        documentation and/or other materials provided with the distribution.
#
#      * Neither the name of Marvell nor the names of its contributors may be
#        used to endorse or promote products derived from this software without
#        specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
# ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
#*******************************************************************************

# get mv_ddr directory path
MV_DDR_ROOT=$1

# get mv_ddr build message and version string c-file name
MV_DDR_VER_CSRC=$2

# get mv_ddr git commit id
MV_DDR_COMMIT_ID=`git -C $MV_DDR_ROOT rev-parse --verify --quiet --short HEAD 2> /dev/null`

# check for uncommitted changes in mv_ddr git
MV_DDR_DIRTY_CHK=`git -C $MV_DDR_ROOT diff-index --name-only HEAD 2> /dev/null`
if [ "$MV_DDR_DIRTY_CHK" != "" ]; then
	MV_DDR_COMMIT_ID="${MV_DDR_COMMIT_ID}-dirty"
fi

# get mv_ddr version from localversion file in mv_ddr directory
MV_DDR_VERSION=`awk '{$1=$1;print}' $MV_DDR_ROOT/localversion 2> /dev/null`
if [ "$MV_DDR_VERSION" = "" ]; then
	MV_DDR_VERSION="unknown"
fi

# set mv_ddr version string to be printed out
if [ "$MV_DDR_COMMIT_ID" = "" ]; then
MV_DDR_VERSION_STRING="mv_ddr: Marvell-${MV_DDR_VERSION} (release)"
else
MV_DDR_VERSION_STRING="mv_ddr: ${MV_DDR_VERSION}-g${MV_DDR_COMMIT_ID}"
fi

# get date and time to set mv_ddr build message
MONTH=`LC_TIME=en_US date +%b`
DAY=`LC_TIME=en_US date +%d`
YEAR=`LC_TIME=en_US date +%Y`
DATE="$MONTH $DAY $YEAR"
TIME=`LC_TIME=en_US date +%X`

# write mv_ddr build message and version string to c-file
echo "const char mv_ddr_build_message[] = \"($DATE - $TIME)\"; \
      const char mv_ddr_version_string[] = \"$MV_DDR_VERSION_STRING\";" > \
      $MV_DDR_ROOT/$MV_DDR_VER_CSRC
