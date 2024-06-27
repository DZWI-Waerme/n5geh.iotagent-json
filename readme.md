# IoT-Agent JSON (Version for DZWI / TUD)

## Customisations
- IoT Agent JSON customisation for automatic data collection as new data points are added 
    - Used for recording simulation data in the DZWI-Project
- Code of the original IoT agent accessible at https://github.com/telefonicaid/iotagent-json
- Added data type identification to the automatic creation of attributes
    - The function normally uses a default value as the data type for unknown attributes
    - The modification checks for data types and uses them instead of the default value.
    - The adjustment is implemented in the function guessType (in https://github.com/telefonicaid/iotagent-json/blob/master/lib/commonBindings.js)
        - New Version in [`./lib/commonBindings.js`](./lib/commonBindings.js)
        - Extension of Function `guessType`:
            ```
            * @param {any}         value       The value of the attribute.

            if (value !== undefined) {
                if (typeof value === 'string') {
                    return 'Text';
                } else if (typeof value === 'number') {
                    return 'Number';
                } else if (typeof value === 'object' && value !== null) {
                    return 'Dict';
                } else {
                    return constants.DEFAULT_ATTRIBUTE_TYPE;
                }
            }
            ```
- Creation of a Docker image with the original image (https://hub.docker.com/r/fiware/iotagent-json) realised
    - Docker image can be created using the enclosed [Dockerfile](./dockerfile)
    - Versions implemented (Usable in the [N5GEH](https://n5geh.de/)):
        - 1.26.0
        - 3.2.0
    - Command to build the docker image: 
        - `docker buildx build --platform linux/amd64 --build-arg VERSION=${VERSION} -t docker-hub.gewv.iet.mw.tu-dresden.de/n5geh/tud-iotagent-json:${VERSION} --push .`


## Usage & Configuration
- It is used in the FIWARE stack of the [N5GEH](https://n5geh.de/)
    - Example of local implementation
- Use of the IoT agent requires configuration via HTTP requests
    - Create service - to IoT-Agent (Read data from MQTT):
        ```
        {
            "services":
            [
                {
                    "apikey":           "dzwi-heat",
                    "type":             "dzwi_heat",
                    "cbroker":          "http://orion:1026",
                    "resource":         "/iot/json",
                    "explicitAttrs":    false,
                    "autoprovision":    true
                }
            ]
        }
        ```
    - Create Subscription - to Orion (send all data to database):
        ```
        {
            "description": "subscription_all",
            "subject": {
                "entities": [
                {
                    "idPattern": ".*",
                    "typePattern": ".*"
                }
                ],
                "condition": {
                    "attrs": []
                }
            },
            "notification": {
                "http": {
                    "url": "http://quantumleap:8668/v2/notify"
                },
                "attrs": [],
                "metadata": ["TimeInstant"],
                "onlyChangedAttrs": true
            },
            "throttling": 0
        }
        ```
- An additional ENV variable ("IOTA_APPEND_MODE=true") is required for use with version 1.26.0

## License

This project is licensed under the AGPL-3.0 license - see the [LICENSE](LICENSE) file for details.

## Copyright

<a href="https://tu-dresden.de/ing/maschinenwesen/iet/gewv"> <img alt="EBC" src="https://raw.githubusercontent.com/N5GEH/.github/main/logos/Logo-Banner-TUD-IET-GEWV.jpg" height="100"> </a>

2020-2024, TUD Dresden University of Technology, Chair of Building Energy Systems and Heat Supply

## Related projects

- EnOB: DZWi - Digital twin of heat generation systems as a trailblazer for the development of low-emission building energy technology <br>
<a href="https://dzwi-waerme.de/"> <img alt="DZWi" 
src="https://avatars.githubusercontent.com/u/83276417" height="150"></a>

- EnOB: N5GEH-Serv - National 5G Energy Hub <br>
<a href="https://n5geh.de/"> <img alt="National 5G Energy Hub" 
src="https://avatars.githubusercontent.com/u/43948851?s=200&v=4" height="150"></a>

## Acknowledgments

We gratefully acknowledge the financial support of the Federal Ministry <br> 
for Economic Affairs and Climate Action (BMWK), promotional reference 03EN1022A.

<a href="https://www.bmwi.de/Navigation/EN/Home/home.html"> <img alt="BMWK" 
src="https://raw.githubusercontent.com/RWTH-EBC/FiLiP/master/docs/logos/bmwi_logo_en.png" height="100"> </a>
