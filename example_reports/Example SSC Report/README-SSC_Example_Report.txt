1. When the report template first loads, it will not be able to load anything because of some report parameters that need to be provided.
2. The problem is that you (as the user) will not know what values to apply to the parameters without first needing to look at some of the datasets in the report template. 
3. To get the report template working, follow these steps:

4. Provide the base URL to your SSC server. Do NOT add in the "/ssc" porttion of the url. Refer to the example provided at the login window. Also provide your API Key. Then click "Connect"
5. Provide a random value for "Application_Version". As an example, just input the letter "a". Then click "Load"
6. When the Refresh window loads, everything will fail. That's okay for now. Just click "Close"
7. In the upper ribbon, click on "Transform Data"
8. Click on "List for parameters" > "listFullPvNames", then from the upper ribbon click "Home" > "Refresh Preview".
9. Click "Close & Apply"
	9-1. Things will fail to load. That's fine for now. Click "Close"
10. Click on the drop-down menu for "Transform data" > "Edit parameters". Click on the down-down menu for "Application_Version" and select one of the available application versions in the list.
11. Click on "Transform data" 
12. Click on the drop-down menu for "Refresh" > "Refresh All".
13. Click "Close & Apply"
14. In the yellow bar at the top of the screen, click "Apply changes".
