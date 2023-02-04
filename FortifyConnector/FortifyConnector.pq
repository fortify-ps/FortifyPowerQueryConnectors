/*
    Developed by: Michael Snowden
*/
[Version = "0.4.0"]
section FortifyConnector;

//// START:  GLOBAL VARIABLES ////
shared splitChar = "\";
//// END: GLOBAL VARIABLES ////

//// START: FUNCTIONS ////
// Getting FoD Auth Token
GetFoDBearerToken = (fodBaseUrl as text) as text => 
    let
        credential = Extension.CurrentCredential(),
        splitKey = if (credential[AuthenticationKind] = "Key")
            then Text.Split(credential[Key], splitChar)
            else null,
        formData = if (credential[AuthenticationKind] = "Key") 
            then  "grant_type=client_credentials"
                & "&scope=api-tenant" 
                & "&client_id=" & splitKey{0}
                & "&client_secret=" & splitKey{1} 
            else  "grant_type=password"
                & "&scope=api-tenant" 
                & "&username=" & credential[Username] 
                & "&password=" & credential[Password]
                & "&security_code=",

        Response = Web.Contents(
            fodBaseUrl & "/oauth/token", 
            [ 
                Content = Text.ToBinary(formData),
                Headers=[ 
                    #"Content-type" = "application/x-www-form-urlencoded; charset=UTF-8", 
                    #"Accept" = "*/*",
                    #"Authorization" = "" // Need to do this to overwrite the Authorization header that Power BI tries to create.
                ]
            ]
        ),
        BearerToken = Json.Document(Response)[access_token]
    in
        BearerToken;

// Retrieve the APIs for a specific FoD instance
GetFoDInstance = (region as text) as table =>
    let
        fodBaseUrl = "https://api." & region & ".fortify.com",
        fodApiUrl = fodBaseUrl & "/swagger/docs/v3",
        headers = [ Authorization = "Bearer " & GetFoDBearerToken(fodBaseUrl) ],
        asNav = OpenApi.Document(Web.Contents(fodApiUrl), [ Headers = headers, ManualCredentials = true, IncludeMoreColumns = true, IncludeExtensions = true ])
    in
        asNav;

GetFodUrl = (region as text) as text =>
    let
        baseUrl = "https://api." & region & ".fortify.com"
    in
        baseUrl;

//// END: FUNCTIONS ////

//// START: CONNECTOR IMPLEMENTATIONS ////
[DataSource.Kind="FortifyConnector.SSC", Publish="FortifyConnector.SSC.Publish"]
shared FortifyConnector.FortifySSC = () =>
    let
        credential = Extension.CurrentCredential(),
        RootUrl = credential[Username],
        BaseUrl = RootUrl,
        TokenServiceUrl = BaseUrl & "/api/v1/tokens",
        ServiceJsonUrl = BaseUrl & "/api/v1/spec.json",
        headers = [ Authorization = "FortifyToken " & credential[Password] ],
        navTable = OpenApi.Document(Web.Contents(ServiceJsonUrl), [ Headers = headers, ManualCredentials = true, IncludeMoreColumns = true, IncludeExtensions = true ])
    in
        navTable;

// Only used to test/debug authentication and other things. Comment out the annotation to disable.
//[DataSource.Kind="FortifyConnector.FOD", Publish="FortifyConnector.FOD.AMS.BearerTest.Publish"]
shared FortifyConnector.FortifyFOD.AMS.BearerTest = () =>
    let
        credential = Extension.CurrentCredential(),
        splitKey = if (credential[AuthenticationKind] = "Key")
            then Text.Split(credential[Key], splitChar)
            else null,
        credInfo = if (credential[AuthenticationKind] = "Key")
            then
                "Full Key = " & credential[Key] 
                & "; Key ID = " &  splitKey{0}
                & "; Key Secret = " &  splitKey{1}
            else "UserName =  " & credential[Username] 
             & "; Password = " & credential[Password],

        //testInfo = [url = GetFodUrl("ams"), bearerToken = GetFoDBearerToken(GetFodUrl("ams")), credentialInfo = credInfo]
        //testInfo = [url = GetFodUrl("ams"), cred1 = splitKey{0}, cred2 = splitKey{1}]
        testInfo = [url = GetFodUrl("ams"), bearerToken = GetFoDBearerToken(GetFodUrl("ams"))]
    in
        testInfo;

[DataSource.Kind="FortifyConnector.FOD.AMS", Publish="FortifyConnector.FOD.AMS.Publish"]
shared FortifyConnector.FortifyFOD.AMS = () =>
    let
        navTable = GetFoDInstance("ams")
    in
        navTable;

[DataSource.Kind="FortifyConnector.FOD.APAC", Publish="FortifyConnector.FOD.APAC.Publish"]
shared FortifyConnector.FortifyFOD.APAC = () =>
    let
        navTable = GetFoDInstance("apac")
    in
        navTable;

[DataSource.Kind="FortifyConnector.FOD.EMEA", Publish="FortifyConnector.FOD.EMEA.Publish"]
shared FortifyConnector.FortifyFOD.EMEA = () =>
    let
        navTable = GetFoDInstance("emea")
    in
        navTable; 
//// END:  CONNECTOR IMPLEMENTATIONS ////

//// START: DATA SOURCE KINDS ////
// Data Source Kind for SSC
FortifyConnector.SSC = [
    Authentication = [
        UsernamePassword = [
            UsernameLabel = Extension.LoadString("ssc_rootUrlLabel"),
            PasswordLabel= Extension.LoadString("ssc_keyLabel"),
            Label= Extension.LoadString("ssc_authKindLabel")
        ]
    ],
    Label = Extension.LoadString("ssc_DataSourceLabel")
];

// Data Source Kind for FoD
FortifyConnector.FOD.AMS = [
    Authentication = [
        Key = [
            KeyLabel = Extension.LoadString("fod_keyLabel"),
            Label = Extension.LoadString("fod_authKindLabel")
        ],
        UsernamePassword = [
            UsernameLabel = Extension.LoadString("fod_usernameLabel"),
            PasswordLabel= Extension.LoadString("fod_passwordLabel"),
            Label= Extension.LoadString("fod_usernamePasswordLabel")
        ]
    ],
    Label = Extension.LoadString("fod_DataSourceLabel") & "-AMS"
];

FortifyConnector.FOD.APAC = [
    Authentication = [
        Key = [
            KeyLabel = Extension.LoadString("fod_keyLabel"),
            Label = Extension.LoadString("fod_authKindLabel")
        ],
        UsernamePassword = [
            UsernameLabel = Extension.LoadString("fod_usernameLabel"),
            PasswordLabel= Extension.LoadString("fod_passwordLabel"),
            Label= Extension.LoadString("fod_usernamePasswordLabel")
        ]
    ],
    Label = Extension.LoadString("fod_DataSourceLabel") & "-APAC"
];

FortifyConnector.FOD.EMEA = [
    Authentication = [
        Key = [
            KeyLabel = Extension.LoadString("fod_keyLabel"),
            Label = Extension.LoadString("fod_authKindLabel")
        ],
        UsernamePassword = [
            UsernameLabel = Extension.LoadString("fod_usernameLabel"),
            PasswordLabel= Extension.LoadString("fod_passwordLabel"),
            Label= Extension.LoadString("fod_usernamePasswordLabel")
        ]
    ],
    Label = Extension.LoadString("fod_DataSourceLabel") & "-EMEA"
];
//// END: DATA SOURCE KINDS ////

//// START: PUBLISHING DEFINITIONS ////
// Data Source UI publishing description for SSC
FortifyConnector.SSC.Publish = [
    Beta = true,
    Category = "Other",
    ButtonText = { Extension.LoadString("ssc_ButtonTitle"), Extension.LoadString("ssc_ButtonHelp") },
    LearnMoreUrl = "https://www.microfocus.com/en-us/cyberres/application-security",
    SourceImage = FortifyConnector.Icons,
    SourceTypeImage = FortifyConnector.Icons
];

// Data Source UI publishing descriptions for FoD
// This is just one for testing purposes (FortifyConnector.FOD.AMS.BearerTest.Publish)
FortifyConnector.FOD.AMS.BearerTest.Publish = [
    Beta = true,
    Category = "Other",
    ButtonText = { Extension.LoadString("fod_ButtonTitleAmsBearerTest"), Extension.LoadString("fod_ButtonHelpAmsBearerTest") },
    LearnMoreUrl = "https://www.microfocus.com/en-us/cyberres/application-security",
    SourceImage = FortifyConnector.Icons,
    SourceTypeImage = FortifyConnector.Icons
];

FortifyConnector.FOD.AMS.Publish = [
    Beta = true,
    Category = "Other",
    ButtonText = { Extension.LoadString("fod_ButtonTitleAms"), Extension.LoadString("fod_ButtonHelpAms") },
    LearnMoreUrl = "https://www.microfocus.com/en-us/cyberres/application-security",
    SourceImage = FortifyConnector.Icons,
    SourceTypeImage = FortifyConnector.Icons
];

FortifyConnector.FOD.APAC.Publish = [
    Beta = true,
    Category = "Other",
    ButtonText = { Extension.LoadString("fod_ButtonTitleApac"), Extension.LoadString("fod_ButtonHelpApac") },
    LearnMoreUrl = "https://www.microfocus.com/en-us/cyberres/application-security",
    SourceImage = FortifyConnector.Icons,
    SourceTypeImage = FortifyConnector.Icons
];

FortifyConnector.FOD.EMEA.Publish = [
    Beta = true,
    Category = "Other",
    ButtonText = { Extension.LoadString("fod_ButtonTitleEmea"), Extension.LoadString("fod_ButtonHelpEmea") },
    LearnMoreUrl = "https://www.microfocus.com/en-us/cyberres/application-security",
    SourceImage = FortifyConnector.Icons,
    SourceTypeImage = FortifyConnector.Icons
];
//// END: PUBLISHING DEFINITIONS ////

FortifyConnector.Icons = [
    Icon16 = { Extension.Contents("FortifyConnector16.png"), Extension.Contents("FortifyConnector20.png"), Extension.Contents("FortifyConnector24.png"), Extension.Contents("FortifyConnector32.png") },
    Icon32 = { Extension.Contents("FortifyConnector32.png"), Extension.Contents("FortifyConnector40.png"), Extension.Contents("FortifyConnector48.png"), Extension.Contents("FortifyConnector64.png") }
];