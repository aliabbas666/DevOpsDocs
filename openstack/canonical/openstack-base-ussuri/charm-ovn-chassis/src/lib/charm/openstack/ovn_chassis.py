# Copyright 2019 Canonical Ltd
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#  http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import charms_openstack.charm as charm

import charms.ovn_charm


charm.use_defaults('charm.default-select-release')


class TrainOVNChassisCharm(charms.ovn_charm.BaseTrainOVNChassisCharm):
    # OpenvSwitch and OVN is distributed as part of the Ubuntu Cloud Archive
    # Pockets get their name from OpenStack releases
    release = 'train'
    name = 'ovn-chassis'

    # Setting an empty source_config_key activates special handling of release
    # selection suitable for subordinate charms
    source_config_key = ''


class UssuriOVNChassisCharm(charms.ovn_charm.BaseUssuriOVNChassisCharm):
    # OpenvSwitch and OVN is distributed as part of the Ubuntu Cloud Archive
    # Pockets get their name from OpenStack releases
    release = 'ussuri'
    name = 'ovn-chassis'

    # Setting an empty source_config_key activates special handling of release
    # selection suitable for subordinate charms
    source_config_key = ''
