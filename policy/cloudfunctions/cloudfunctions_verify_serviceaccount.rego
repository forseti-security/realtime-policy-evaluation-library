# Copyright 2019 The resource-policy-evaluation-library Authors. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


package gcp.cloudfunctions.projects.locations.functions.policy.verify_serviceaccount

#####
# Resource metadata
#####

labels = input.labels

#####
# Policy evaluation
#####

default valid = false

# Check if default service account is used
valid = true {
  input.serviceAccountEmail == serviceAccountEmail
}

# Check for a global exclusion based on resource labels
valid = true {
  data.exclusions.label_exclude(labels)
}

#####
# Remediation
#####

# Since we cannot remediate it, if policy fails lets end it with "No possible remediation"
remediate[key] = value {
  input.serviceAccountEmail == serviceAccountEmail
  input[key]=value
}

# extract project name from function name
projectNamePart = split(input.name, "/")
# construct email for default cloud function service account
serviceAccountEmail = concat("@", [projectNamePart[1], "appspot.gserviceaccount.com"])