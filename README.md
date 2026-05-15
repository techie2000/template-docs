# Crest

This repository captures vendor (Euroclear) documentation and internal notes related to the CREST[^1] system.

There is no application code in this repository; it serves as a reference store for documentation gathered during any CREST project work.

## Structure

| Folder                             | Purpose                                                                     |
| ---------------------------------- | --------------------------------------------------------------------------- |
| `[docs/vendor/](docs/vendor/)`     | Vendor-supplied documentation, data sheets, manuals, and reference material |
| `[docs/internal/](docs/internal/)` | Internal notes, decisions, and meeting records                              |

## Access

| Env./Service | <font color="red">Finastra Prod</font>                                                                                                                      | <font color="gree">Finastra DR</font>                                                                                                                      |
| ------------ | ---------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- |
| <font color="red">PROD</font>         | [https://cwg-pr.fundtech-fm.com:39000/Api/welcome?webui=PROD](https://cwg-pr.fundtech-fm.com:39000/Api/welcome?webui=PROD)         | [https://cwg-dr.fundtech-fm.com:39000/Api/welcome?webui=PROD](https://cwg-dr.fundtech-fm.com:39000/Api/welcome?webui=PROD)       |
| ONDEMAND     | [https://cwg-pr.fundtech-fm.com:39000/Api/welcome?webui=ONDEMAND](https://cwg-pr.fundtech-fm.com:39000/Api/welcome?webui=ONDEMAND) | [https://cwg-dr.fundtech-fm.com:39000/Api/welcome?webui=ONDEMAND](https://cwg-dr.fundtech-fm.com:39000/Api/welcome?webui=)       |
| RAT1EXT      | [https://cwg-pr.fundtech-fm.com:39000/Api/welcome?webui=RAT1EXT](https://cwg-pr.fundtech-fm.com:39000/Api/welcome?webui=RAT1EXT)   | [https://cwg-dr.fundtech-fm.com:39000/Api/welcome?webui=RAT1EXT](https://cwg-dr.fundtech-fm.com:39000/Api/welcome?webui=RAT1EXT) |
| RAT2EXT      | [https://cwg-pr.fundtech-fm.com:39000/Api/welcome?webui=RAT2EXT](https://cwg-pr.fundtech-fm.com:39000/Api/welcome?webui=RAT2EXT)   | [https://cwg-dr.fundtech-fm.com:39000/Api/welcome?webui=RAT2EXT](https://cwg-dr.fundtech-fm.com:39000/Api/welcome?webui=RAT2EXT) |
| RAT3EXT      | [https://cwg-pr.fundtech-fm.com:39000/Api/welcome?webui=RAT3EXT](https://cwg-pr.fundtech-fm.com:39000/Api/welcome?webui=RAT3EXT)   | [https://cwg-dr.fundtech-fm.com:39000/Api/welcome?webui=RAT3EXT](https://cwg-dr.fundtech-fm.com:39000/Api/welcome?webui=RAT3EXT) |

Access is a multi-stage process:

1. Connect via one of the Access Links above (e.g. [RAT2](https://cwg-pr.fundtech-fm.com:39000/Api/welcome?webui=RAT2EXT))
2. Pick an Environment, e.g. 'Test System E' (as used in UAT/PAT (Participant Acceptance Testing) pri to go-live)
![image](./images/crest-environment-selection.png)  
3. Sign-in to the SWIFT Gateway  
![image](./images/crest-gateway-signon.png)  
4. Login to CREST  
![image](./images/crest-login.png)

> [!IMPORTANT]
> NOTE: The username is likely to be the same on both the SWIFT Gateway sign-on as the CREST Login BUT DOES NOT HAVE TO BE. i.e. the Gateway has no knowledge of CREST users and vice versa. For this reason, the passwords are independent as well.

## Footnotes

[^1]: Certificateless Registry for Electronic Share Transfer
