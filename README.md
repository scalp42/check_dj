# DESCRIPTION:

Nagios check for a host running Delayed::Job ([https://github.com/collectiveidea/delayed_job](http://)) workers. Also comes with a restart-handler in case a worker is missing (or dead). 

Ruby (_yaml) and Bash (deprecated) versions available.

# REQUIREMENTS:

Currently, you need to edit yourself the "map" of dj workers in the check itself, as it returns the missing workers in the output (**only required for the bash version**)

You also need to make sure that user "nagios" can ssh into the hosts failing (to restart the dj workers from RAILS_ROOT).

Finally, nagios user will need sudo privileges. Please add the following to your sudoers configuration (change according to your configuration) :

	nagios ALL=(ALL) NOPASSWD:"command to start a dj worker, dj_exec?"

# USAGE:

Edit your nagios configuration to include something like this :

	define service{
        	use generic-service
	        host_name localhost
	        service_description check_dj
	       	check_command check_dj
       		event_handler restart-dj-worker
	}

Specify the path to your YAML (**if using the Ruby version**).

# TODO (bash version, deprecated):

- The check is slow as it's parsing ps output (sys 0m2.592s). Maybe need to look into pgrep or figure a way to speed it up.

- Allows number of workers that should be verified to be passed to the check directly, something like check_dj -n 20

- Figure how to restart properly the worker.

- Figure the problem with priorities (each worker has a different priority)

# LICENSE & AUTHOR:

Author:: Anthony Scalisi (scalisi.a@gmail.com)

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.