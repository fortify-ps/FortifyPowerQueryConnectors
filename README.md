# FortifyPowerQueryConnectors
Power Query (Power BI) Connectors for Fortify

Disclaimer
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

Introduction
====
The Visual Studio solution houses projects for the various Power Query Connectors that can connect to the various Fortify products to extract information for the purpose of creating custom dashboards and reports in Power BI.

So far the following connectors have been created:
 - Fortify SSC
 - Fortify on Demand - AMS
 - Fortify on Demand - EMEA
 - Fortify on Demand - APAC

Installing the connectors
====
- For Power BI:
  * https://docs.microsoft.com/en-us/power-bi/connect-data/service-gateway-custom-connectors
- For Power BI Desktop:
  * https://community.powerbi.com/t5/Desktop/To-Enable-custom-connector-in-Power-bi-desktop/m-p/917540


Building from source
====

Prerequisites
----
- Visual Studio 2019
- Power Query SDK

Building the solution/projects
----
1. Get VS 2019 and install the Power Query SDK ([link][1])
2. Open the solution and build/rebuild it

[1]: https://marketplace.visualstudio.com/items?itemName=Dakahn.PowerQuerySDK
