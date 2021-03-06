#
# Author:: Patrick Connolly <patrick@myplanetdigital.com>
#
# Cookbook Name:: php
# Attributes:: module_memcached
#
# Copyright 2009-2011, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

default['php']['pear']['directives']['memcached'] = {
  "sess_locking"          => "On",
  "sess_lock_wait"        => "150000",
  "sess_prefix"           => "memc.sess.key.",
  "compression_type"      => "fastlz",
  "compression_factor"    => "1.3",
  "compression_threshold" => "2000",
  "serializer"            => "igbinary",
}
