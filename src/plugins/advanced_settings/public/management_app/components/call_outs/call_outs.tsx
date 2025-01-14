/*
 * SPDX-License-Identifier: Apache-2.0
 *
 * The OpenSearch Contributors require contributions made to
 * this file be licensed under the Apache-2.0 license or a
 * compatible open source license.
 *
 * Any modifications Copyright OpenSearch Contributors. See
 * GitHub history for details.
 */

/*
 * Licensed to Elasticsearch B.V. under one or more contributor
 * license agreements. See the NOTICE file distributed with
 * this work for additional information regarding copyright
 * ownership. Elasticsearch B.V. licenses this file to you under
 * the Apache License, Version 2.0 (the "License"); you may
 * not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

import React from 'react';

import { EuiCallOut } from '@elastic/eui';
import { FormattedMessage } from '@osd/i18n/react';

export const CallOuts = () => {
  return (
    <div>
      <EuiCallOut
        title={
          <FormattedMessage
            id="advancedSettings.callOutCautionTitle"
            defaultMessage="Caution: You can break stuff here"
          />
        }
        color="warning"
        iconType="bolt"
      >
        <p>
          <FormattedMessage
            id="advancedSettings.callOutCautionDescription"
            defaultMessage="Be careful in here, these settings are for very advanced users only.
            Tweaks you make here can break large portions of Cyb3rhq dashboard.
            Some of these settings may be undocumented, unsupported or experimental.
            If a field has a default value, blanking the field will reset it to its default which may be
            unacceptable given other configuration directives.
            Deleting a custom setting will permanently remove it from Cyb3rhq Dashboard's config."
          />
        </p>
      </EuiCallOut>
    </div>
  );
};
