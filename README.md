# FortifyPowerQueryConnectors
Power Query (Power BI) Connectors for Fortify

Disclaimer:
====
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY 
KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE 
WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR 
PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, 
DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF 
CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN 
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
DEALINGS IN THE SOFTWARE.

Introduction:
====
The Visual Studio Code project houses multiple connectors that can connect to the various Fortify products to extract information for the purpose of creating custom dashboards and reports in Power BI.

So far the following connectors have been created:
 - Fortify SSC
 - Fortify on Demand - AMS
 - Fortify on Demand - EMEA
 - Fortify on Demand - APAC

Important Notes:
===
The most recent version of the connector (v2.x) has undergone a major rewrite in order to:
- Migrate the project to using VS Code in stead of Visual Studio
- Consolidate the code for the connectors for SSC and FoD, into a single project which will produce a single MEZ connector file.

SSC usability notes:
- There is no option to authenticate with user credentials. Only API keys can be used

FoD usability notes:
- "FoD Basic Login" will not work for tenants with multi-factor authentication (MFA) enabled. If MFA is enabled, you will need to use "Client ID & Secret" to authenticate.
- The Fed instance of FoD is not supported as I do not have access to that instance to test. If you need support for this, contact me directly and I'll try and offer assistance to you to add in support yourself.

Installing the connectors:
====
The latest compiled connectors are available in the [releases][2] page.
- For Power BI:
  * https://docs.microsoft.com/en-us/power-bi/connect-data/service-gateway-custom-connectors
- For Power BI Desktop:
  * https://community.powerbi.com/t5/Desktop/To-Enable-custom-connector-in-Power-bi-desktop/m-p/917540


Building from source:
====

Prerequisites:
----
- Windows OS
- Visual Studio Code
- Power Query SDK Extension

Building:
----
You have two options. You can either:
- Run the build task from within VS Code
- Or you can run the following command in powershell, after installing the prerequisites:
  - `& "${home}\.vscode\extensions\powerquery.vscode-powerquery-sdk-0.2.1-win32-x64\.nuget\Microsoft.PowerQuery.SdkTools.2.112.4\tools\MakePQX.exe" compile`

[1]: https://marketplace.visualstudio.com/items?itemName=PowerQuery.vscode-powerquery-sdk
[2]: https://github.com/fortify-ps/FortifyPowerQueryConnectors/releases
