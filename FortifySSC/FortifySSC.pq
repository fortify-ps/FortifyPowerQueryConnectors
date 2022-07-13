// This file contains your Data Connector logic
section FortifySSC;

RootUrl = "changeme";
BaseUrl = "changeme";
TokenServiceUrl = "changeme";
ServiceJsonUrl = "changeme";

/* 
    NOTE: Power BI does not support custom fields for any of the authentication types that it supports.
          As a workaround, the UsernamePassword auth type is used so that the Username can be used 
          for the base URL of SSC and the Password can be used for the API Key.
*/

[DataSource.Kind="FortifySSC", Publish="FortifySSC.Publish"]
shared FortifySSC.Contents = (optional message as text) =>
    let
        credential = Extension.CurrentCredential(),
        RootUrl = credential[Username],
        BaseUrl = RootUrl & "/",
        TokenServiceUrl = BaseUrl & "/api/v1/tokens",
        ServiceJsonUrl = BaseUrl & "/api/v1/spec.json",
        headers = [ Authorization = "FortifyToken " & credential[Password] ],
        //navTable = OpenApi.Document(Web.Contents(ServiceJsonUrl), [ Headers = headers, ManualCredentials = true, IncludeMoreColumns = true, IncludeExtensions = true ])

        //Doing this because Fortify SSC (as of version 20.2) still does not include a value for schema. This causes issues when trying to connect to ssc with HTTPS enabled.
        json = Extension.Contents("ssc.json"),
        scheme = Text.Split(RootUrl, ":"){0},
        host = Text.Split(RootUrl,"/"){2},
        updatedJson = Text.Format(Text.FromBinary(json), {scheme, host}),
        navTable = OpenApi.Document(Text.ToBinary(updatedJson), [ Headers = headers, ManualCredentials = true, IncludeMoreColumns = false, IncludeExtensions = true ])
    in
        navTable;

// Data Source Kind description
FortifySSC = [
    Authentication = [
        UsernamePassword = [
            UsernameLabel = Extension.LoadString("rootUrlLabel"),
            PasswordLabel= Extension.LoadString("keyLabel"),
            Label= Extension.LoadString("authKindLabel")
        ]
    ],
    Label = Extension.LoadString("DataSourceLabel")
];

// Data Source UI publishing description
FortifySSC.Publish = [
    Beta = true,
    Category = "Other",
    ButtonText = { Extension.LoadString("ButtonTitle"), Extension.LoadString("ButtonHelp") },
    LearnMoreUrl = "https://www.microfocus.com/en-us/cyberres/application-security",
    SourceImage = FortifySSC.Icons,
    SourceTypeImage = FortifySSC.Icons
];

FortifySSC.Icons = [
    Icon16 = { Extension.Contents("FortifySSC16.png"), Extension.Contents("FortifySSC20.png"), Extension.Contents("FortifySSC24.png"), Extension.Contents("FortifySSC32.png") },
    Icon32 = { Extension.Contents("FortifySSC32.png"), Extension.Contents("FortifySSC40.png"), Extension.Contents("FortifySSC48.png"), Extension.Contents("FortifySSC64.png") }
];
