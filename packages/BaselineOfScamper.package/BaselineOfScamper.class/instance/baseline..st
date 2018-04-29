baseline
baseline: spec
    <baseline>
    spec
        for: #'common'
        do: [ 
            spec
                package: 'Scamper-Compatibility';
               package: 'HTML';
                package: 'Scamper' with: [ spec requires: #('HTML' 'Scamper-Compatibility') ].
            spec
                group: 'default' with: #('Scamper');
                group: 'tests' with: #('Scamper') ]