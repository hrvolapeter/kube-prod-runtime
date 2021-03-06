/*
 * Bitnami Kubernetes Production Runtime - A collection of services that makes it
 * easy to run production workloads in Kubernetes.
 *
 * Copyright 2018-2019 Bitnami
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

local kubecfg = import "kubecfg.libsonnet";

{
  rules+: {
    test_:: {
      groups: [
        {
          name: "test.rules",
          rules: [
            {
              alert: "CrashLooping_test",
              expr: "sum(rate(kube_pod_container_status_restarts_total[10m])) BY (namespace, container) * 600 > 0",
              labels: {severity: "critical"},
            },
          ],
        },
      ],
    },
    "test.yaml": kubecfg.manifestYaml(self.test_),
  },

  am_config+: {
    route+: {
      group_interval: "30s",
      repeat_interval: "1m",
    },
  },
}
