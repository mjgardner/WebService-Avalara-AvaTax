# Operation GetTaxSoapIn
#           INPUT, document literal
# Produced  by XML::Compile::SOAP11::Operation version 3.08
#           on Wed Mar 11 15:25:00 2015
#
# The output below is only an example: it cannot be used
# without interpretation, although very close to real code.

# Compile only once in your code, usually during initiation:
#   my $call = $wsdl->compileClient('GetTax');
# then call it as often as you need.  Alternatively
#   $wsdl->compileCalls();   # once
#   $response = $wsdl->call('GetTax', $request);
# The details of the types and elements are attached below.

# Header part 'Profile' is element tns:Profile
my $Profile = {};

# Header part 'wsse_Security' is element wsse:Security
my $wsse_Security = {};

# Body part 'parameters' is element tns:GetTax
my $parameters = {};

# Call with the combination of parts.
my @params = (
    Profile => $Profile,
    wsse_Security => $wsse_Security,
    parameters => $parameters,
);
my ($answer, $trace) = $call->(@params);

# @params will become %$data_in in the server handler.
# $answer is a HASH, an operation OUTPUT or Fault.
# $trace is an XML::Compile::SOAP::Trace object.

# You may get an error back from the server
if(my $f = $answer->{Fault})
{   my $errname = $f->{_NAME};
    my $error   = $answer->{$errname};
    print "$error->{code}\n";

    my $details = $error->{detail};
    if(not $details)
    {   # system error, no $details
    }
    exit 1;
}

#--------------------------------------------------------------
$Profile =
# Describing complex tns:Profile
#     {http://avatax.avalara.com/services}Profile
# xmlns:tns       http://avatax.avalara.com/services

# is a tns:Profile
{ # any attribute in any namespace
  ANYATTR => "AnySimple",

  # sequence of Name, Client, Adapter, Machine

  # is a xs:string
  # is optional
  Name => "example",

  # is a xs:string
  # is optional
  Client => "example",

  # is a xs:string
  # is optional
  Adapter => "example",

  # is a xs:string
  # is optional
  Machine => "example", }

;

#--------------------------------------------------------------
$wsse_Security =
# Describing complex wsse:Security
#     {http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd}Security
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:wsse      http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd
# xmlns:xs        http://www.w3.org/2001/XMLSchema

# is a wsse:SecurityHeaderType
{ # any attribute not in wsse:
  ANYATTR => "AnySimple",

  # sequence of ANY

  # any element in any namespace
  # occurs any number of times
  ANY => [ "Anything", ], }

;

#--------------------------------------------------------------
$parameters =
# Describing complex tns:GetTax
#     {http://avatax.avalara.com/services}GetTax
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:wsse      http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd

# is an unnamed complex
{ # sequence of GetTaxRequest

  # is a tns:GetTaxRequest
  # is optional
  GetTaxRequest =>
  { # sequence of CompanyCode, DocType, DocCode, DocDate,
    #   SalespersonCode, CustomerCode, CustomerUsageType, Discount,
    #   PurchaseOrderNo, ExemptionNo, OriginCode, DestinationCode,
    #   Addresses, Lines, DetailLevel, ReferenceCode, HashCode,
    #   LocationCode, Commit, BatchCode, TaxOverride, CurrencyCode,
    #   ServiceMode, PaymentDate, ExchangeRate, ExchangeRateEffDate,
    #   PosLaneCode, BusinessIdentificationNo

    # is a xs:string
    # is optional
    CompanyCode => "example",

    # is a xs:string
    # Enum: InventoryTransferInvoice InventoryTransferOrder
    #    PurchaseInvoice PurchaseOrder ReturnInvoice
    #    ReturnOrder ReverseChargeInvoice ReverseChargeOrder
    #    SalesInvoice SalesOrder
    DocType => "SalesOrder",

    # is a xs:string
    # is optional
    DocCode => "example",

    # is a xs:date
    DocDate => "2006-10-06",

    # is a xs:string
    # is optional
    SalespersonCode => "example",

    # is a xs:string
    # is optional
    CustomerCode => "example",

    # is a xs:string
    # is optional
    CustomerUsageType => "example",

    # is a xs:decimal
    Discount => 3.1415,

    # is a xs:string
    # is optional
    PurchaseOrderNo => "example",

    # is a xs:string
    # is optional
    ExemptionNo => "example",

    # is a xs:string
    # is optional
    OriginCode => "example",

    # is a xs:string
    # is optional
    DestinationCode => "example",

    # is a tns:ArrayOfBaseAddress
    # is optional
    Addresses =>
    { # sequence of BaseAddress

      # is a tns:BaseAddress
      # is nillable, as: BaseAddress => NIL
      # occurs any number of times
      BaseAddress =>
      [ { # sequence of AddressCode, Line1, Line2, Line3, City, Region,
          #   PostalCode, Country, TaxRegionId, Latitude, Longitude

          # is a xs:string
          # is optional
          AddressCode => "example",

          # is a xs:string
          # is optional
          Line1 => "example",

          # is a xs:string
          # is optional
          Line2 => "example",

          # is a xs:string
          # is optional
          Line3 => "example",

          # is a xs:string
          # is optional
          City => "example",

          # is a xs:string
          # is optional
          Region => "example",

          # is a xs:string
          # is optional
          PostalCode => "example",

          # is a xs:string
          # is optional
          Country => "example",

          # is a xs:int
          TaxRegionId => 42,

          # is a xs:string
          # is optional
          Latitude => "example",

          # is a xs:string
          # is optional
          Longitude => "example", }, ], },

    # is a tns:ArrayOfLine
    # is optional
    Lines =>
    { # sequence of Line

      # is a tns:Line
      # is nillable, as: Line => NIL
      # occurs any number of times
      Line =>
      [ { # sequence of No, OriginCode, DestinationCode, ItemCode,
          #   TaxCode, Qty, Amount, Discounted, RevAcct, Ref1, Ref2,
          #   ExemptionNo, CustomerUsageType, Description, TaxOverride,
          #   TaxIncluded, BusinessIdentificationNo

          # is a xs:string
          # is optional
          No => "example",

          # is a xs:string
          # is optional
          OriginCode => "example",

          # is a xs:string
          # is optional
          DestinationCode => "example",

          # is a xs:string
          # is optional
          ItemCode => "example",

          # is a xs:string
          # is optional
          TaxCode => "example",

          # is a xs:decimal
          Qty => 3.1415,

          # is a xs:decimal
          Amount => 3.1415,

          # is a xs:boolean
          Discounted => "true",

          # is a xs:string
          # is optional
          RevAcct => "example",

          # is a xs:string
          # is optional
          Ref1 => "example",

          # is a xs:string
          # is optional
          Ref2 => "example",

          # is a xs:string
          # is optional
          ExemptionNo => "example",

          # is a xs:string
          # is optional
          CustomerUsageType => "example",

          # is a xs:string
          # is optional
          Description => "example",

          # is a tns:TaxOverride
          # is optional
          TaxOverride =>
          { # sequence of TaxOverrideType, TaxAmount, TaxDate, Reason

            # is a xs:string
            # Enum: AccruedTaxAmount DeriveTaxable Exemption None
            #    TaxAmount TaxDate
            TaxOverrideType => "None",

            # is a xs:decimal
            TaxAmount => 3.1415,

            # is a xs:date
            TaxDate => "2006-10-06",

            # is a xs:string
            # is optional
            Reason => "example", },

          # is a xs:boolean
          # defaults to 'false'
          TaxIncluded => "false",

          # is a xs:string
          # is optional
          BusinessIdentificationNo => "example", }, ], },

    # is a xs:string
    # Enum: Diagnostic Document Line Summary Tax
    DetailLevel => "Document",

    # is a xs:string
    # is optional
    ReferenceCode => "example",

    # is a xs:int
    HashCode => 42,

    # is a xs:string
    # is optional
    LocationCode => "example",

    # is a xs:boolean
    Commit => "true",

    # is a xs:string
    # is optional
    BatchCode => "example",

    # is a tns:TaxOverride
    # complex structure shown above
    # is optional
    TaxOverride => [{},],

    # is a xs:string
    # is optional
    CurrencyCode => "example",

    # is a xs:string
    # Enum: Automatic Local Remote
    ServiceMode => "Automatic",

    # is a xs:date
    PaymentDate => "2006-10-06",

    # is a xs:decimal
    ExchangeRate => 3.1415,

    # is a xs:date
    ExchangeRateEffDate => "2006-10-06",

    # is a xs:string
    # is optional
    PosLaneCode => "example",

    # is a xs:string
    # is optional
    BusinessIdentificationNo => "example", }, }

;

# Operation GetTaxHistorySoapIn
#           INPUT, document literal
# Produced  by XML::Compile::SOAP11::Operation version 3.08
#           on Wed Mar 11 15:25:00 2015
#
# The output below is only an example: it cannot be used
# without interpretation, although very close to real code.

# Compile only once in your code, usually during initiation:
#   my $call = $wsdl->compileClient('GetTaxHistory');
# then call it as often as you need.  Alternatively
#   $wsdl->compileCalls();   # once
#   $response = $wsdl->call('GetTaxHistory', $request);
# The details of the types and elements are attached below.

# Header part 'Profile' is element tns:Profile
my $Profile = {};

# Header part 'wsse_Security' is element wsse:Security
my $wsse_Security = {};

# Body part 'parameters' is element tns:GetTaxHistory
my $parameters = {};

# Call with the combination of parts.
my @params = (
    Profile => $Profile,
    wsse_Security => $wsse_Security,
    parameters => $parameters,
);
my ($answer, $trace) = $call->(@params);

# @params will become %$data_in in the server handler.
# $answer is a HASH, an operation OUTPUT or Fault.
# $trace is an XML::Compile::SOAP::Trace object.

# You may get an error back from the server
if(my $f = $answer->{Fault})
{   my $errname = $f->{_NAME};
    my $error   = $answer->{$errname};
    print "$error->{code}\n";

    my $details = $error->{detail};
    if(not $details)
    {   # system error, no $details
    }
    exit 1;
}

#--------------------------------------------------------------
$Profile =
# Describing complex tns:Profile
#     {http://avatax.avalara.com/services}Profile
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:xs        http://www.w3.org/2001/XMLSchema

# is a tns:Profile
{ # any attribute in any namespace
  ANYATTR => "AnySimple",

  # sequence of Name, Client, Adapter, Machine

  # is a xs:string
  # is optional
  Name => "example",

  # is a xs:string
  # is optional
  Client => "example",

  # is a xs:string
  # is optional
  Adapter => "example",

  # is a xs:string
  # is optional
  Machine => "example", }

;

#--------------------------------------------------------------
$wsse_Security =
# Describing complex wsse:Security
#     {http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd}Security
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:wsse      http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd
# xmlns:xs        http://www.w3.org/2001/XMLSchema

# is a wsse:SecurityHeaderType
{ # any attribute not in wsse:
  ANYATTR => "AnySimple",

  # sequence of ANY

  # any element in any namespace
  # occurs any number of times
  ANY => [ "Anything", ], }

;

#--------------------------------------------------------------
$parameters =
# Describing complex tns:GetTaxHistory
#     {http://avatax.avalara.com/services}GetTaxHistory
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:wsse      http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd

# is an unnamed complex
{ # sequence of GetTaxHistoryRequest

  # is a tns:GetTaxHistoryRequest
  # is optional
  GetTaxHistoryRequest =>
  { # sequence of DocId, CompanyCode, DocType, DocCode, DetailLevel

    # is a xs:string
    # is optional
    DocId => "example",

    # is a xs:string
    # is optional
    CompanyCode => "example",

    # is a xs:string
    # Enum: InventoryTransferInvoice InventoryTransferOrder
    #    PurchaseInvoice PurchaseOrder ReturnInvoice
    #    ReturnOrder ReverseChargeInvoice ReverseChargeOrder
    #    SalesInvoice SalesOrder
    DocType => "SalesOrder",

    # is a xs:string
    # is optional
    DocCode => "example",

    # is a xs:string
    # Enum: Diagnostic Document Line Summary Tax
    DetailLevel => "Document", }, }

;

# Operation PostTaxSoapIn
#           INPUT, document literal
# Produced  by XML::Compile::SOAP11::Operation version 3.08
#           on Wed Mar 11 15:25:00 2015
#
# The output below is only an example: it cannot be used
# without interpretation, although very close to real code.

# Compile only once in your code, usually during initiation:
#   my $call = $wsdl->compileClient('PostTax');
# then call it as often as you need.  Alternatively
#   $wsdl->compileCalls();   # once
#   $response = $wsdl->call('PostTax', $request);
# The details of the types and elements are attached below.

# Header part 'Profile' is element tns:Profile
my $Profile = {};

# Header part 'wsse_Security' is element wsse:Security
my $wsse_Security = {};

# Body part 'parameters' is element tns:PostTax
my $parameters = {};

# Call with the combination of parts.
my @params = (
    Profile => $Profile,
    wsse_Security => $wsse_Security,
    parameters => $parameters,
);
my ($answer, $trace) = $call->(@params);

# @params will become %$data_in in the server handler.
# $answer is a HASH, an operation OUTPUT or Fault.
# $trace is an XML::Compile::SOAP::Trace object.

# You may get an error back from the server
if(my $f = $answer->{Fault})
{   my $errname = $f->{_NAME};
    my $error   = $answer->{$errname};
    print "$error->{code}\n";

    my $details = $error->{detail};
    if(not $details)
    {   # system error, no $details
    }
    exit 1;
}

#--------------------------------------------------------------
$Profile =
# Describing complex tns:Profile
#     {http://avatax.avalara.com/services}Profile
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:xs        http://www.w3.org/2001/XMLSchema

# is a tns:Profile
{ # any attribute in any namespace
  ANYATTR => "AnySimple",

  # sequence of Name, Client, Adapter, Machine

  # is a xs:string
  # is optional
  Name => "example",

  # is a xs:string
  # is optional
  Client => "example",

  # is a xs:string
  # is optional
  Adapter => "example",

  # is a xs:string
  # is optional
  Machine => "example", }

;

#--------------------------------------------------------------
$wsse_Security =
# Describing complex wsse:Security
#     {http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd}Security
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:wsse      http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd
# xmlns:xs        http://www.w3.org/2001/XMLSchema

# is a wsse:SecurityHeaderType
{ # any attribute not in wsse:
  ANYATTR => "AnySimple",

  # sequence of ANY

  # any element in any namespace
  # occurs any number of times
  ANY => [ "Anything", ], }

;

#--------------------------------------------------------------
$parameters =
# Describing complex tns:PostTax
#     {http://avatax.avalara.com/services}PostTax
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:wsse      http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd

# is an unnamed complex
{ # sequence of PostTaxRequest

  # is a tns:PostTaxRequest
  # is optional
  PostTaxRequest =>
  { # sequence of DocId, CompanyCode, DocType, DocCode, DocDate,
    #   TotalAmount, TotalTax, HashCode, Commit, NewDocCode

    # is a xs:string
    # is optional
    DocId => "example",

    # is a xs:string
    # is optional
    CompanyCode => "example",

    # is a xs:string
    # Enum: InventoryTransferInvoice InventoryTransferOrder
    #    PurchaseInvoice PurchaseOrder ReturnInvoice
    #    ReturnOrder ReverseChargeInvoice ReverseChargeOrder
    #    SalesInvoice SalesOrder
    DocType => "SalesOrder",

    # is a xs:string
    # is optional
    DocCode => "example",

    # is a xs:date
    DocDate => "2006-10-06",

    # is a xs:decimal
    TotalAmount => 3.1415,

    # is a xs:decimal
    TotalTax => 3.1415,

    # is a xs:int
    HashCode => 42,

    # is a xs:boolean
    Commit => "true",

    # is a xs:string
    # is optional
    NewDocCode => "example", }, }

;

# Operation CommitTaxSoapIn
#           INPUT, document literal
# Produced  by XML::Compile::SOAP11::Operation version 3.08
#           on Wed Mar 11 15:25:00 2015
#
# The output below is only an example: it cannot be used
# without interpretation, although very close to real code.

# Compile only once in your code, usually during initiation:
#   my $call = $wsdl->compileClient('CommitTax');
# then call it as often as you need.  Alternatively
#   $wsdl->compileCalls();   # once
#   $response = $wsdl->call('CommitTax', $request);
# The details of the types and elements are attached below.

# Header part 'AuditMessage' is element tns:AuditMessage
my $AuditMessage = {};

# Header part 'Profile' is element tns:Profile
my $Profile = {};

# Header part 'wsse_Security' is element wsse:Security
my $wsse_Security = {};

# Body part 'parameters' is element tns:CommitTax
my $parameters = {};

# Call with the combination of parts.
my @params = (
    AuditMessage => $AuditMessage,
    Profile => $Profile,
    wsse_Security => $wsse_Security,
    parameters => $parameters,
);
my ($answer, $trace) = $call->(@params);

# @params will become %$data_in in the server handler.
# $answer is a HASH, an operation OUTPUT or Fault.
# $trace is an XML::Compile::SOAP::Trace object.

# You may get an error back from the server
if(my $f = $answer->{Fault})
{   my $errname = $f->{_NAME};
    my $error   = $answer->{$errname};
    print "$error->{code}\n";

    my $details = $error->{detail};
    if(not $details)
    {   # system error, no $details
    }
    exit 1;
}

#--------------------------------------------------------------
$AuditMessage =
# Describing complex tns:AuditMessage
#     {http://avatax.avalara.com/services}AuditMessage
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:xs        http://www.w3.org/2001/XMLSchema

# is a tns:AuditMessage
{ # any attribute in any namespace
  ANYATTR => "AnySimple",

  # sequence of Message

  # is a xs:string
  # is optional
  Message => "example", }

;

#--------------------------------------------------------------
$Profile =
# Describing complex tns:Profile
#     {http://avatax.avalara.com/services}Profile
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:xs        http://www.w3.org/2001/XMLSchema

# is a tns:Profile
{ # any attribute in any namespace
  ANYATTR => "AnySimple",

  # sequence of Name, Client, Adapter, Machine

  # is a xs:string
  # is optional
  Name => "example",

  # is a xs:string
  # is optional
  Client => "example",

  # is a xs:string
  # is optional
  Adapter => "example",

  # is a xs:string
  # is optional
  Machine => "example", }

;

#--------------------------------------------------------------
$wsse_Security =
# Describing complex wsse:Security
#     {http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd}Security
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:wsse      http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd
# xmlns:xs        http://www.w3.org/2001/XMLSchema

# is a wsse:SecurityHeaderType
{ # any attribute not in wsse:
  ANYATTR => "AnySimple",

  # sequence of ANY

  # any element in any namespace
  # occurs any number of times
  ANY => [ "Anything", ], }

;

#--------------------------------------------------------------
$parameters =
# Describing complex tns:CommitTax
#     {http://avatax.avalara.com/services}CommitTax
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:wsse      http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd

# is an unnamed complex
{ # sequence of CommitTaxRequest

  # is a tns:CommitTaxRequest
  # is optional
  CommitTaxRequest =>
  { # sequence of DocId, CompanyCode, DocType, DocCode, NewDocCode

    # is a xs:string
    # is optional
    DocId => "example",

    # is a xs:string
    # is optional
    CompanyCode => "example",

    # is a xs:string
    # Enum: InventoryTransferInvoice InventoryTransferOrder
    #    PurchaseInvoice PurchaseOrder ReturnInvoice
    #    ReturnOrder ReverseChargeInvoice ReverseChargeOrder
    #    SalesInvoice SalesOrder
    DocType => "SalesOrder",

    # is a xs:string
    # is optional
    DocCode => "example",

    # is a xs:string
    # is optional
    NewDocCode => "example", }, }

;

# Operation CancelTaxSoapIn
#           INPUT, document literal
# Produced  by XML::Compile::SOAP11::Operation version 3.08
#           on Wed Mar 11 15:25:00 2015
#
# The output below is only an example: it cannot be used
# without interpretation, although very close to real code.

# Compile only once in your code, usually during initiation:
#   my $call = $wsdl->compileClient('CancelTax');
# then call it as often as you need.  Alternatively
#   $wsdl->compileCalls();   # once
#   $response = $wsdl->call('CancelTax', $request);
# The details of the types and elements are attached below.

# Header part 'AuditMessage' is element tns:AuditMessage
my $AuditMessage = {};

# Header part 'Profile' is element tns:Profile
my $Profile = {};

# Header part 'wsse_Security' is element wsse:Security
my $wsse_Security = {};

# Body part 'parameters' is element tns:CancelTax
my $parameters = {};

# Call with the combination of parts.
my @params = (
    AuditMessage => $AuditMessage,
    Profile => $Profile,
    wsse_Security => $wsse_Security,
    parameters => $parameters,
);
my ($answer, $trace) = $call->(@params);

# @params will become %$data_in in the server handler.
# $answer is a HASH, an operation OUTPUT or Fault.
# $trace is an XML::Compile::SOAP::Trace object.

# You may get an error back from the server
if(my $f = $answer->{Fault})
{   my $errname = $f->{_NAME};
    my $error   = $answer->{$errname};
    print "$error->{code}\n";

    my $details = $error->{detail};
    if(not $details)
    {   # system error, no $details
    }
    exit 1;
}

#--------------------------------------------------------------
$AuditMessage =
# Describing complex tns:AuditMessage
#     {http://avatax.avalara.com/services}AuditMessage
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:xs        http://www.w3.org/2001/XMLSchema

# is a tns:AuditMessage
{ # any attribute in any namespace
  ANYATTR => "AnySimple",

  # sequence of Message

  # is a xs:string
  # is optional
  Message => "example", }

;

#--------------------------------------------------------------
$Profile =
# Describing complex tns:Profile
#     {http://avatax.avalara.com/services}Profile
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:xs        http://www.w3.org/2001/XMLSchema

# is a tns:Profile
{ # any attribute in any namespace
  ANYATTR => "AnySimple",

  # sequence of Name, Client, Adapter, Machine

  # is a xs:string
  # is optional
  Name => "example",

  # is a xs:string
  # is optional
  Client => "example",

  # is a xs:string
  # is optional
  Adapter => "example",

  # is a xs:string
  # is optional
  Machine => "example", }

;

#--------------------------------------------------------------
$wsse_Security =
# Describing complex wsse:Security
#     {http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd}Security
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:wsse      http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd
# xmlns:xs        http://www.w3.org/2001/XMLSchema

# is a wsse:SecurityHeaderType
{ # any attribute not in wsse:
  ANYATTR => "AnySimple",

  # sequence of ANY

  # any element in any namespace
  # occurs any number of times
  ANY => [ "Anything", ], }

;

#--------------------------------------------------------------
$parameters =
# Describing complex tns:CancelTax
#     {http://avatax.avalara.com/services}CancelTax
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:wsse      http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd

# is an unnamed complex
{ # sequence of CancelTaxRequest

  # is a tns:CancelTaxRequest
  # is optional
  CancelTaxRequest =>
  { # sequence of DocId, CompanyCode, DocType, DocCode, CancelCode

    # is a xs:string
    # is optional
    DocId => "example",

    # is a xs:string
    # is optional
    CompanyCode => "example",

    # is a xs:string
    # Enum: InventoryTransferInvoice InventoryTransferOrder
    #    PurchaseInvoice PurchaseOrder ReturnInvoice
    #    ReturnOrder ReverseChargeInvoice ReverseChargeOrder
    #    SalesInvoice SalesOrder
    DocType => "SalesOrder",

    # is a xs:string
    # is optional
    DocCode => "example",

    # is a xs:string
    # Enum: AdjustmentCancelled DocDeleted DocVoided
    #    PostFailed Unspecified
    CancelCode => "Unspecified", }, }

;

# Operation ReconcileTaxHistorySoapIn
#           INPUT, document literal
# Produced  by XML::Compile::SOAP11::Operation version 3.08
#           on Wed Mar 11 15:25:00 2015
#
# The output below is only an example: it cannot be used
# without interpretation, although very close to real code.

# Compile only once in your code, usually during initiation:
#   my $call = $wsdl->compileClient('ReconcileTaxHistory');
# then call it as often as you need.  Alternatively
#   $wsdl->compileCalls();   # once
#   $response = $wsdl->call('ReconcileTaxHistory', $request);
# The details of the types and elements are attached below.

# Header part 'Profile' is element tns:Profile
my $Profile = {};

# Header part 'wsse_Security' is element wsse:Security
my $wsse_Security = {};

# Body part 'parameters' is element tns:ReconcileTaxHistory
my $parameters = {};

# Call with the combination of parts.
my @params = (
    Profile => $Profile,
    wsse_Security => $wsse_Security,
    parameters => $parameters,
);
my ($answer, $trace) = $call->(@params);

# @params will become %$data_in in the server handler.
# $answer is a HASH, an operation OUTPUT or Fault.
# $trace is an XML::Compile::SOAP::Trace object.

# You may get an error back from the server
if(my $f = $answer->{Fault})
{   my $errname = $f->{_NAME};
    my $error   = $answer->{$errname};
    print "$error->{code}\n";

    my $details = $error->{detail};
    if(not $details)
    {   # system error, no $details
    }
    exit 1;
}

#--------------------------------------------------------------
$Profile =
# Describing complex tns:Profile
#     {http://avatax.avalara.com/services}Profile
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:xs        http://www.w3.org/2001/XMLSchema

# is a tns:Profile
{ # any attribute in any namespace
  ANYATTR => "AnySimple",

  # sequence of Name, Client, Adapter, Machine

  # is a xs:string
  # is optional
  Name => "example",

  # is a xs:string
  # is optional
  Client => "example",

  # is a xs:string
  # is optional
  Adapter => "example",

  # is a xs:string
  # is optional
  Machine => "example", }

;

#--------------------------------------------------------------
$wsse_Security =
# Describing complex wsse:Security
#     {http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd}Security
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:wsse      http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd
# xmlns:xs        http://www.w3.org/2001/XMLSchema

# is a wsse:SecurityHeaderType
{ # any attribute not in wsse:
  ANYATTR => "AnySimple",

  # sequence of ANY

  # any element in any namespace
  # occurs any number of times
  ANY => [ "Anything", ], }

;

#--------------------------------------------------------------
$parameters =
# Describing complex tns:ReconcileTaxHistory
#     {http://avatax.avalara.com/services}ReconcileTaxHistory
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:wsse      http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd

# is an unnamed complex
{ # sequence of ReconcileTaxHistoryRequest

  # is a tns:ReconcileTaxHistoryRequest
  # is optional
  ReconcileTaxHistoryRequest =>
  { # sequence of CompanyCode, LastDocId, Reconciled, StartDate,
    #   EndDate, DocStatus, DocType, LastDocCode, PageSize

    # is a xs:string
    # is optional
    CompanyCode => "example",

    # is a xs:string
    # is optional
    LastDocId => "example",

    # is a xs:boolean
    Reconciled => "true",

    # is a xs:date
    StartDate => "2006-10-06",

    # is a xs:date
    EndDate => "2006-10-06",

    # is a xs:string
    # Enum: Adjusted Any Cancelled Committed Posted Saved
    #    Temporary
    DocStatus => "Temporary",

    # is a xs:string
    # Enum: InventoryTransferInvoice InventoryTransferOrder
    #    PurchaseInvoice PurchaseOrder ReturnInvoice
    #    ReturnOrder ReverseChargeInvoice ReverseChargeOrder
    #    SalesInvoice SalesOrder
    DocType => "SalesOrder",

    # is a xs:string
    LastDocCode => "example",

    # is a xs:int
    PageSize => 42, }, }

;

# Operation AdjustTaxSoapIn
#           INPUT, document literal
# Produced  by XML::Compile::SOAP11::Operation version 3.08
#           on Wed Mar 11 15:25:00 2015
#
# The output below is only an example: it cannot be used
# without interpretation, although very close to real code.

# Compile only once in your code, usually during initiation:
#   my $call = $wsdl->compileClient('AdjustTax');
# then call it as often as you need.  Alternatively
#   $wsdl->compileCalls();   # once
#   $response = $wsdl->call('AdjustTax', $request);
# The details of the types and elements are attached below.

# Header part 'Profile' is element tns:Profile
my $Profile = {};

# Header part 'wsse_Security' is element wsse:Security
my $wsse_Security = {};

# Body part 'parameters' is element tns:AdjustTax
my $parameters = {};

# Call with the combination of parts.
my @params = (
    Profile => $Profile,
    wsse_Security => $wsse_Security,
    parameters => $parameters,
);
my ($answer, $trace) = $call->(@params);

# @params will become %$data_in in the server handler.
# $answer is a HASH, an operation OUTPUT or Fault.
# $trace is an XML::Compile::SOAP::Trace object.

# You may get an error back from the server
if(my $f = $answer->{Fault})
{   my $errname = $f->{_NAME};
    my $error   = $answer->{$errname};
    print "$error->{code}\n";

    my $details = $error->{detail};
    if(not $details)
    {   # system error, no $details
    }
    exit 1;
}

#--------------------------------------------------------------
$Profile =
# Describing complex tns:Profile
#     {http://avatax.avalara.com/services}Profile
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:xs        http://www.w3.org/2001/XMLSchema

# is a tns:Profile
{ # any attribute in any namespace
  ANYATTR => "AnySimple",

  # sequence of Name, Client, Adapter, Machine

  # is a xs:string
  # is optional
  Name => "example",

  # is a xs:string
  # is optional
  Client => "example",

  # is a xs:string
  # is optional
  Adapter => "example",

  # is a xs:string
  # is optional
  Machine => "example", }

;

#--------------------------------------------------------------
$wsse_Security =
# Describing complex wsse:Security
#     {http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd}Security
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:wsse      http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd
# xmlns:xs        http://www.w3.org/2001/XMLSchema

# is a wsse:SecurityHeaderType
{ # any attribute not in wsse:
  ANYATTR => "AnySimple",

  # sequence of ANY

  # any element in any namespace
  # occurs any number of times
  ANY => [ "Anything", ], }

;

#--------------------------------------------------------------
$parameters =
# Describing complex tns:AdjustTax
#     {http://avatax.avalara.com/services}AdjustTax
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:wsse      http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd

# is an unnamed complex
{ # sequence of AdjustTaxRequest

  # is a tns:AdjustTaxRequest
  # is optional
  AdjustTaxRequest =>
  { # sequence of AdjustmentReason, AdjustmentDescription,
    #   GetTaxRequest

    # is a xs:int
    AdjustmentReason => 42,

    # is a xs:string
    # is optional
    AdjustmentDescription => "example",

    # is a tns:GetTaxRequest
    # is optional
    GetTaxRequest =>
    { # sequence of CompanyCode, DocType, DocCode, DocDate,
      #   SalespersonCode, CustomerCode, CustomerUsageType, Discount,
      #   PurchaseOrderNo, ExemptionNo, OriginCode, DestinationCode,
      #   Addresses, Lines, DetailLevel, ReferenceCode, HashCode,
      #   LocationCode, Commit, BatchCode, TaxOverride, CurrencyCode,
      #   ServiceMode, PaymentDate, ExchangeRate, ExchangeRateEffDate,
      #   PosLaneCode, BusinessIdentificationNo

      # is a xs:string
      # is optional
      CompanyCode => "example",

      # is a xs:string
      # Enum: InventoryTransferInvoice InventoryTransferOrder
      #    PurchaseInvoice PurchaseOrder ReturnInvoice
      #    ReturnOrder ReverseChargeInvoice ReverseChargeOrder
      #    SalesInvoice SalesOrder
      DocType => "SalesOrder",

      # is a xs:string
      # is optional
      DocCode => "example",

      # is a xs:date
      DocDate => "2006-10-06",

      # is a xs:string
      # is optional
      SalespersonCode => "example",

      # is a xs:string
      # is optional
      CustomerCode => "example",

      # is a xs:string
      # is optional
      CustomerUsageType => "example",

      # is a xs:decimal
      Discount => 3.1415,

      # is a xs:string
      # is optional
      PurchaseOrderNo => "example",

      # is a xs:string
      # is optional
      ExemptionNo => "example",

      # is a xs:string
      # is optional
      OriginCode => "example",

      # is a xs:string
      # is optional
      DestinationCode => "example",

      # is a tns:ArrayOfBaseAddress
      # is optional
      Addresses =>
      { # sequence of BaseAddress

        # is a tns:BaseAddress
        # is nillable, as: BaseAddress => NIL
        # occurs any number of times
        BaseAddress =>
        [ { # sequence of AddressCode, Line1, Line2, Line3, City, Region,
            #   PostalCode, Country, TaxRegionId, Latitude, Longitude

            # is a xs:string
            # is optional
            AddressCode => "example",

            # is a xs:string
            # is optional
            Line1 => "example",

            # is a xs:string
            # is optional
            Line2 => "example",

            # is a xs:string
            # is optional
            Line3 => "example",

            # is a xs:string
            # is optional
            City => "example",

            # is a xs:string
            # is optional
            Region => "example",

            # is a xs:string
            # is optional
            PostalCode => "example",

            # is a xs:string
            # is optional
            Country => "example",

            # is a xs:int
            TaxRegionId => 42,

            # is a xs:string
            # is optional
            Latitude => "example",

            # is a xs:string
            # is optional
            Longitude => "example", }, ], },

      # is a tns:ArrayOfLine
      # is optional
      Lines =>
      { # sequence of Line

        # is a tns:Line
        # is nillable, as: Line => NIL
        # occurs any number of times
        Line =>
        [ { # sequence of No, OriginCode, DestinationCode, ItemCode,
            #   TaxCode, Qty, Amount, Discounted, RevAcct, Ref1, Ref2,
            #   ExemptionNo, CustomerUsageType, Description, TaxOverride,
            #   TaxIncluded, BusinessIdentificationNo

            # is a xs:string
            # is optional
            No => "example",

            # is a xs:string
            # is optional
            OriginCode => "example",

            # is a xs:string
            # is optional
            DestinationCode => "example",

            # is a xs:string
            # is optional
            ItemCode => "example",

            # is a xs:string
            # is optional
            TaxCode => "example",

            # is a xs:decimal
            Qty => 3.1415,

            # is a xs:decimal
            Amount => 3.1415,

            # is a xs:boolean
            Discounted => "true",

            # is a xs:string
            # is optional
            RevAcct => "example",

            # is a xs:string
            # is optional
            Ref1 => "example",

            # is a xs:string
            # is optional
            Ref2 => "example",

            # is a xs:string
            # is optional
            ExemptionNo => "example",

            # is a xs:string
            # is optional
            CustomerUsageType => "example",

            # is a xs:string
            # is optional
            Description => "example",

            # is a tns:TaxOverride
            # is optional
            TaxOverride =>
            { # sequence of TaxOverrideType, TaxAmount, TaxDate, Reason

              # is a xs:string
              # Enum: AccruedTaxAmount DeriveTaxable Exemption None
              #    TaxAmount TaxDate
              TaxOverrideType => "None",

              # is a xs:decimal
              TaxAmount => 3.1415,

              # is a xs:date
              TaxDate => "2006-10-06",

              # is a xs:string
              # is optional
              Reason => "example", },

            # is a xs:boolean
            # defaults to 'false'
            TaxIncluded => "false",

            # is a xs:string
            # is optional
            BusinessIdentificationNo => "example", }, ], },

      # is a xs:string
      # Enum: Diagnostic Document Line Summary Tax
      DetailLevel => "Document",

      # is a xs:string
      # is optional
      ReferenceCode => "example",

      # is a xs:int
      HashCode => 42,

      # is a xs:string
      # is optional
      LocationCode => "example",

      # is a xs:boolean
      Commit => "true",

      # is a xs:string
      # is optional
      BatchCode => "example",

      # is a tns:TaxOverride
      # complex structure shown above
      # is optional
      TaxOverride => [{},],

      # is a xs:string
      # is optional
      CurrencyCode => "example",

      # is a xs:string
      # Enum: Automatic Local Remote
      ServiceMode => "Automatic",

      # is a xs:date
      PaymentDate => "2006-10-06",

      # is a xs:decimal
      ExchangeRate => 3.1415,

      # is a xs:date
      ExchangeRateEffDate => "2006-10-06",

      # is a xs:string
      # is optional
      PosLaneCode => "example",

      # is a xs:string
      # is optional
      BusinessIdentificationNo => "example", }, }, }

;

# Operation ApplyPaymentSoapIn
#           INPUT, document literal
# Produced  by XML::Compile::SOAP11::Operation version 3.08
#           on Wed Mar 11 15:25:00 2015
#
# The output below is only an example: it cannot be used
# without interpretation, although very close to real code.

# Compile only once in your code, usually during initiation:
#   my $call = $wsdl->compileClient('ApplyPayment');
# then call it as often as you need.  Alternatively
#   $wsdl->compileCalls();   # once
#   $response = $wsdl->call('ApplyPayment', $request);
# The details of the types and elements are attached below.

# Header part 'AuditMessage' is element tns:AuditMessage
my $AuditMessage = {};

# Header part 'Profile' is element tns:Profile
my $Profile = {};

# Header part 'wsse_Security' is element wsse:Security
my $wsse_Security = {};

# Body part 'parameters' is element tns:ApplyPayment
my $parameters = {};

# Call with the combination of parts.
my @params = (
    AuditMessage => $AuditMessage,
    Profile => $Profile,
    wsse_Security => $wsse_Security,
    parameters => $parameters,
);
my ($answer, $trace) = $call->(@params);

# @params will become %$data_in in the server handler.
# $answer is a HASH, an operation OUTPUT or Fault.
# $trace is an XML::Compile::SOAP::Trace object.

# You may get an error back from the server
if(my $f = $answer->{Fault})
{   my $errname = $f->{_NAME};
    my $error   = $answer->{$errname};
    print "$error->{code}\n";

    my $details = $error->{detail};
    if(not $details)
    {   # system error, no $details
    }
    exit 1;
}

#--------------------------------------------------------------
$AuditMessage =
# Describing complex tns:AuditMessage
#     {http://avatax.avalara.com/services}AuditMessage
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:xs        http://www.w3.org/2001/XMLSchema

# is a tns:AuditMessage
{ # any attribute in any namespace
  ANYATTR => "AnySimple",

  # sequence of Message

  # is a xs:string
  # is optional
  Message => "example", }

;

#--------------------------------------------------------------
$Profile =
# Describing complex tns:Profile
#     {http://avatax.avalara.com/services}Profile
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:xs        http://www.w3.org/2001/XMLSchema

# is a tns:Profile
{ # any attribute in any namespace
  ANYATTR => "AnySimple",

  # sequence of Name, Client, Adapter, Machine

  # is a xs:string
  # is optional
  Name => "example",

  # is a xs:string
  # is optional
  Client => "example",

  # is a xs:string
  # is optional
  Adapter => "example",

  # is a xs:string
  # is optional
  Machine => "example", }

;

#--------------------------------------------------------------
$wsse_Security =
# Describing complex wsse:Security
#     {http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd}Security
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:wsse      http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd
# xmlns:xs        http://www.w3.org/2001/XMLSchema

# is a wsse:SecurityHeaderType
{ # any attribute not in wsse:
  ANYATTR => "AnySimple",

  # sequence of ANY

  # any element in any namespace
  # occurs any number of times
  ANY => [ "Anything", ], }

;

#--------------------------------------------------------------
$parameters =
# Describing complex tns:ApplyPayment
#     {http://avatax.avalara.com/services}ApplyPayment
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:wsse      http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd

# is an unnamed complex
{ # sequence of ApplyPaymentRequest

  # is a tns:ApplyPaymentRequest
  # is optional
  ApplyPaymentRequest =>
  { # sequence of DocId, CompanyCode, DocType, DocCode, PaymentDate

    # is a xs:string
    # is optional
    DocId => "example",

    # is a xs:string
    # is optional
    CompanyCode => "example",

    # is a xs:string
    # Enum: InventoryTransferInvoice InventoryTransferOrder
    #    PurchaseInvoice PurchaseOrder ReturnInvoice
    #    ReturnOrder ReverseChargeInvoice ReverseChargeOrder
    #    SalesInvoice SalesOrder
    DocType => "SalesOrder",

    # is a xs:string
    # is optional
    DocCode => "example",

    # is a xs:date
    PaymentDate => "2006-10-06", }, }

;

# Operation PingSoapIn
#           INPUT, document literal
# Produced  by XML::Compile::SOAP11::Operation version 3.08
#           on Wed Mar 11 15:25:00 2015
#
# The output below is only an example: it cannot be used
# without interpretation, although very close to real code.

# Compile only once in your code, usually during initiation:
#   my $call = $wsdl->compileClient('Ping');
# then call it as often as you need.  Alternatively
#   $wsdl->compileCalls();   # once
#   $response = $wsdl->call('Ping', $request);
# The details of the types and elements are attached below.

# Header part 'Profile' is element tns:Profile
my $Profile = {};

# Header part 'wsse_Security' is element wsse:Security
my $wsse_Security = {};

# Body part 'parameters' is element tns:Ping
my $parameters = {};

# Call with the combination of parts.
my @params = (
    Profile => $Profile,
    wsse_Security => $wsse_Security,
    parameters => $parameters,
);
my ($answer, $trace) = $call->(@params);

# @params will become %$data_in in the server handler.
# $answer is a HASH, an operation OUTPUT or Fault.
# $trace is an XML::Compile::SOAP::Trace object.

# You may get an error back from the server
if(my $f = $answer->{Fault})
{   my $errname = $f->{_NAME};
    my $error   = $answer->{$errname};
    print "$error->{code}\n";

    my $details = $error->{detail};
    if(not $details)
    {   # system error, no $details
    }
    exit 1;
}

#--------------------------------------------------------------
$Profile =
# Describing complex tns:Profile
#     {http://avatax.avalara.com/services}Profile
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:xs        http://www.w3.org/2001/XMLSchema

# is a tns:Profile
{ # any attribute in any namespace
  ANYATTR => "AnySimple",

  # sequence of Name, Client, Adapter, Machine

  # is a xs:string
  # is optional
  Name => "example",

  # is a xs:string
  # is optional
  Client => "example",

  # is a xs:string
  # is optional
  Adapter => "example",

  # is a xs:string
  # is optional
  Machine => "example", }

;

#--------------------------------------------------------------
$wsse_Security =
# Describing complex wsse:Security
#     {http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd}Security
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:wsse      http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd
# xmlns:xs        http://www.w3.org/2001/XMLSchema

# is a wsse:SecurityHeaderType
{ # any attribute not in wsse:
  ANYATTR => "AnySimple",

  # sequence of ANY

  # any element in any namespace
  # occurs any number of times
  ANY => [ "Anything", ], }

;

#--------------------------------------------------------------
$parameters =
# Describing complex tns:Ping
#     {http://avatax.avalara.com/services}Ping
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:wsse      http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd

# is an unnamed complex
{ # sequence of Message

  # is a xs:string
  # is optional
  Message => "example", }

;

# Operation IsAuthorizedSoapIn
#           INPUT, document literal
# Produced  by XML::Compile::SOAP11::Operation version 3.08
#           on Wed Mar 11 15:25:00 2015
#
# The output below is only an example: it cannot be used
# without interpretation, although very close to real code.

# Compile only once in your code, usually during initiation:
#   my $call = $wsdl->compileClient('IsAuthorized');
# then call it as often as you need.  Alternatively
#   $wsdl->compileCalls();   # once
#   $response = $wsdl->call('IsAuthorized', $request);
# The details of the types and elements are attached below.

# Header part 'Profile' is element tns:Profile
my $Profile = {};

# Header part 'wsse_Security' is element wsse:Security
my $wsse_Security = {};

# Body part 'parameters' is element tns:IsAuthorized
my $parameters = {};

# Call with the combination of parts.
my @params = (
    Profile => $Profile,
    wsse_Security => $wsse_Security,
    parameters => $parameters,
);
my ($answer, $trace) = $call->(@params);

# @params will become %$data_in in the server handler.
# $answer is a HASH, an operation OUTPUT or Fault.
# $trace is an XML::Compile::SOAP::Trace object.

# You may get an error back from the server
if(my $f = $answer->{Fault})
{   my $errname = $f->{_NAME};
    my $error   = $answer->{$errname};
    print "$error->{code}\n";

    my $details = $error->{detail};
    if(not $details)
    {   # system error, no $details
    }
    exit 1;
}

#--------------------------------------------------------------
$Profile =
# Describing complex tns:Profile
#     {http://avatax.avalara.com/services}Profile
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:xs        http://www.w3.org/2001/XMLSchema

# is a tns:Profile
{ # any attribute in any namespace
  ANYATTR => "AnySimple",

  # sequence of Name, Client, Adapter, Machine

  # is a xs:string
  # is optional
  Name => "example",

  # is a xs:string
  # is optional
  Client => "example",

  # is a xs:string
  # is optional
  Adapter => "example",

  # is a xs:string
  # is optional
  Machine => "example", }

;

#--------------------------------------------------------------
$wsse_Security =
# Describing complex wsse:Security
#     {http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd}Security
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:wsse      http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd
# xmlns:xs        http://www.w3.org/2001/XMLSchema

# is a wsse:SecurityHeaderType
{ # any attribute not in wsse:
  ANYATTR => "AnySimple",

  # sequence of ANY

  # any element in any namespace
  # occurs any number of times
  ANY => [ "Anything", ], }

;

#--------------------------------------------------------------
$parameters =
# Describing complex tns:IsAuthorized
#     {http://avatax.avalara.com/services}IsAuthorized
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:wsse      http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd

# is an unnamed complex
{ # sequence of Operations

  # is a xs:string
  # is optional
  Operations => "example", }

;

# Operation TaxSummaryFetchSoapIn
#           INPUT, document literal
# Produced  by XML::Compile::SOAP11::Operation version 3.08
#           on Wed Mar 11 15:25:00 2015
#
# The output below is only an example: it cannot be used
# without interpretation, although very close to real code.

# Compile only once in your code, usually during initiation:
#   my $call = $wsdl->compileClient('TaxSummaryFetch');
# then call it as often as you need.  Alternatively
#   $wsdl->compileCalls();   # once
#   $response = $wsdl->call('TaxSummaryFetch', $request);
# The details of the types and elements are attached below.

# Header part 'Profile' is element tns:Profile
my $Profile = {};

# Header part 'wsse_Security' is element wsse:Security
my $wsse_Security = {};

# Body part 'parameters' is element tns:TaxSummaryFetch
my $parameters = {};

# Call with the combination of parts.
my @params = (
    Profile => $Profile,
    wsse_Security => $wsse_Security,
    parameters => $parameters,
);
my ($answer, $trace) = $call->(@params);

# @params will become %$data_in in the server handler.
# $answer is a HASH, an operation OUTPUT or Fault.
# $trace is an XML::Compile::SOAP::Trace object.

# You may get an error back from the server
if(my $f = $answer->{Fault})
{   my $errname = $f->{_NAME};
    my $error   = $answer->{$errname};
    print "$error->{code}\n";

    my $details = $error->{detail};
    if(not $details)
    {   # system error, no $details
    }
    exit 1;
}

#--------------------------------------------------------------
$Profile =
# Describing complex tns:Profile
#     {http://avatax.avalara.com/services}Profile
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:xs        http://www.w3.org/2001/XMLSchema

# is a tns:Profile
{ # any attribute in any namespace
  ANYATTR => "AnySimple",

  # sequence of Name, Client, Adapter, Machine

  # is a xs:string
  # is optional
  Name => "example",

  # is a xs:string
  # is optional
  Client => "example",

  # is a xs:string
  # is optional
  Adapter => "example",

  # is a xs:string
  # is optional
  Machine => "example", }

;

#--------------------------------------------------------------
$wsse_Security =
# Describing complex wsse:Security
#     {http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd}Security
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:wsse      http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd
# xmlns:xs        http://www.w3.org/2001/XMLSchema

# is a wsse:SecurityHeaderType
{ # any attribute not in wsse:
  ANYATTR => "AnySimple",

  # sequence of ANY

  # any element in any namespace
  # occurs any number of times
  ANY => [ "Anything", ], }

;

#--------------------------------------------------------------
$parameters =
# Describing complex tns:TaxSummaryFetch
#     {http://avatax.avalara.com/services}TaxSummaryFetch
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:wsse      http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd

# is an unnamed complex
{ # sequence of TaxSummaryFetchRequest

  # is a tns:TaxSummaryFetchRequest
  # is optional
  TaxSummaryFetchRequest =>
  { # sequence of MerchantCode, StartDate, EndDate

    # is a xs:string
    # is optional
    MerchantCode => "example",

    # is a xs:date
    StartDate => "2006-10-06",

    # is a xs:date
    EndDate => "2006-10-06", }, }

;

# Operation GetTaxSoapIn
#           INPUT, document literal
# Produced  by XML::Compile::SOAP12::Operation version 3.03
#           on Wed Mar 11 15:25:00 2015
#
# The output below is only an example: it cannot be used
# without interpretation, although very close to real code.

# Compile only once in your code, usually during initiation:
my $call = $wsdl->compileClient('GetTax');
# ... then call it as often as you need.
# The details of the types and elements are attached below.

# Header part 'Profile' is element tns:Profile
my $Profile = {};

# Header part 'wsse_Security' is element wsse:Security
my $wsse_Security = {};

# Body part 'parameters' is element tns:GetTax
my $parameters = {};

# Call with the combination of parts.
my @params = (
    Profile => $Profile,
    wsse_Security => $wsse_Security,
    parameters => $parameters,
);
my ($answer, $trace) = $call->(@params);

# @params will become %$data_in in the server handler.
# $answer is a HASH, an operation OUTPUT or Fault.
# $trace is an XML::Compile::SOAP::Trace object.

# You may get an error back from the server
if(my $f = $answer->{Fault})
{   my $errname = $f->{_NAME};
    my $error   = $answer->{$errname};
    print "$error->{code}\n";

    my $details = $error->{detail};
    if(not $details)
    {   # system error, no $details
    }
    exit 1;
}

#--------------------------------------------------------------
$Profile =
# Describing complex tns:Profile
#     {http://avatax.avalara.com/services}Profile
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:xs        http://www.w3.org/2001/XMLSchema

# is a tns:Profile
{ # any attribute in any namespace
  ANYATTR => "AnySimple",

  # sequence of Name, Client, Adapter, Machine

  # is a xs:string
  # is optional
  Name => "example",

  # is a xs:string
  # is optional
  Client => "example",

  # is a xs:string
  # is optional
  Adapter => "example",

  # is a xs:string
  # is optional
  Machine => "example", }

;

#--------------------------------------------------------------
$wsse_Security =
# Describing complex wsse:Security
#     {http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd}Security
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:wsse      http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd
# xmlns:xs        http://www.w3.org/2001/XMLSchema

# is a wsse:SecurityHeaderType
{ # any attribute not in wsse:
  ANYATTR => "AnySimple",

  # sequence of ANY

  # any element in any namespace
  # occurs any number of times
  ANY => [ "Anything", ], }

;

#--------------------------------------------------------------
$parameters =
# Describing complex tns:GetTax
#     {http://avatax.avalara.com/services}GetTax
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:wsse      http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd

# is an unnamed complex
{ # sequence of GetTaxRequest

  # is a tns:GetTaxRequest
  # is optional
  GetTaxRequest =>
  { # sequence of CompanyCode, DocType, DocCode, DocDate,
    #   SalespersonCode, CustomerCode, CustomerUsageType, Discount,
    #   PurchaseOrderNo, ExemptionNo, OriginCode, DestinationCode,
    #   Addresses, Lines, DetailLevel, ReferenceCode, HashCode,
    #   LocationCode, Commit, BatchCode, TaxOverride, CurrencyCode,
    #   ServiceMode, PaymentDate, ExchangeRate, ExchangeRateEffDate,
    #   PosLaneCode, BusinessIdentificationNo

    # is a xs:string
    # is optional
    CompanyCode => "example",

    # is a xs:string
    # Enum: InventoryTransferInvoice InventoryTransferOrder
    #    PurchaseInvoice PurchaseOrder ReturnInvoice
    #    ReturnOrder ReverseChargeInvoice ReverseChargeOrder
    #    SalesInvoice SalesOrder
    DocType => "SalesOrder",

    # is a xs:string
    # is optional
    DocCode => "example",

    # is a xs:date
    DocDate => "2006-10-06",

    # is a xs:string
    # is optional
    SalespersonCode => "example",

    # is a xs:string
    # is optional
    CustomerCode => "example",

    # is a xs:string
    # is optional
    CustomerUsageType => "example",

    # is a xs:decimal
    Discount => 3.1415,

    # is a xs:string
    # is optional
    PurchaseOrderNo => "example",

    # is a xs:string
    # is optional
    ExemptionNo => "example",

    # is a xs:string
    # is optional
    OriginCode => "example",

    # is a xs:string
    # is optional
    DestinationCode => "example",

    # is a tns:ArrayOfBaseAddress
    # is optional
    Addresses =>
    { # sequence of BaseAddress

      # is a tns:BaseAddress
      # is nillable, as: BaseAddress => NIL
      # occurs any number of times
      BaseAddress =>
      [ { # sequence of AddressCode, Line1, Line2, Line3, City, Region,
          #   PostalCode, Country, TaxRegionId, Latitude, Longitude

          # is a xs:string
          # is optional
          AddressCode => "example",

          # is a xs:string
          # is optional
          Line1 => "example",

          # is a xs:string
          # is optional
          Line2 => "example",

          # is a xs:string
          # is optional
          Line3 => "example",

          # is a xs:string
          # is optional
          City => "example",

          # is a xs:string
          # is optional
          Region => "example",

          # is a xs:string
          # is optional
          PostalCode => "example",

          # is a xs:string
          # is optional
          Country => "example",

          # is a xs:int
          TaxRegionId => 42,

          # is a xs:string
          # is optional
          Latitude => "example",

          # is a xs:string
          # is optional
          Longitude => "example", }, ], },

    # is a tns:ArrayOfLine
    # is optional
    Lines =>
    { # sequence of Line

      # is a tns:Line
      # is nillable, as: Line => NIL
      # occurs any number of times
      Line =>
      [ { # sequence of No, OriginCode, DestinationCode, ItemCode,
          #   TaxCode, Qty, Amount, Discounted, RevAcct, Ref1, Ref2,
          #   ExemptionNo, CustomerUsageType, Description, TaxOverride,
          #   TaxIncluded, BusinessIdentificationNo

          # is a xs:string
          # is optional
          No => "example",

          # is a xs:string
          # is optional
          OriginCode => "example",

          # is a xs:string
          # is optional
          DestinationCode => "example",

          # is a xs:string
          # is optional
          ItemCode => "example",

          # is a xs:string
          # is optional
          TaxCode => "example",

          # is a xs:decimal
          Qty => 3.1415,

          # is a xs:decimal
          Amount => 3.1415,

          # is a xs:boolean
          Discounted => "true",

          # is a xs:string
          # is optional
          RevAcct => "example",

          # is a xs:string
          # is optional
          Ref1 => "example",

          # is a xs:string
          # is optional
          Ref2 => "example",

          # is a xs:string
          # is optional
          ExemptionNo => "example",

          # is a xs:string
          # is optional
          CustomerUsageType => "example",

          # is a xs:string
          # is optional
          Description => "example",

          # is a tns:TaxOverride
          # is optional
          TaxOverride =>
          { # sequence of TaxOverrideType, TaxAmount, TaxDate, Reason

            # is a xs:string
            # Enum: AccruedTaxAmount DeriveTaxable Exemption None
            #    TaxAmount TaxDate
            TaxOverrideType => "None",

            # is a xs:decimal
            TaxAmount => 3.1415,

            # is a xs:date
            TaxDate => "2006-10-06",

            # is a xs:string
            # is optional
            Reason => "example", },

          # is a xs:boolean
          # defaults to 'false'
          TaxIncluded => "false",

          # is a xs:string
          # is optional
          BusinessIdentificationNo => "example", }, ], },

    # is a xs:string
    # Enum: Diagnostic Document Line Summary Tax
    DetailLevel => "Document",

    # is a xs:string
    # is optional
    ReferenceCode => "example",

    # is a xs:int
    HashCode => 42,

    # is a xs:string
    # is optional
    LocationCode => "example",

    # is a xs:boolean
    Commit => "true",

    # is a xs:string
    # is optional
    BatchCode => "example",

    # is a tns:TaxOverride
    # complex structure shown above
    # is optional
    TaxOverride => [{},],

    # is a xs:string
    # is optional
    CurrencyCode => "example",

    # is a xs:string
    # Enum: Automatic Local Remote
    ServiceMode => "Automatic",

    # is a xs:date
    PaymentDate => "2006-10-06",

    # is a xs:decimal
    ExchangeRate => 3.1415,

    # is a xs:date
    ExchangeRateEffDate => "2006-10-06",

    # is a xs:string
    # is optional
    PosLaneCode => "example",

    # is a xs:string
    # is optional
    BusinessIdentificationNo => "example", }, }

;

# Operation GetTaxHistorySoapIn
#           INPUT, document literal
# Produced  by XML::Compile::SOAP12::Operation version 3.03
#           on Wed Mar 11 15:25:00 2015
#
# The output below is only an example: it cannot be used
# without interpretation, although very close to real code.

# Compile only once in your code, usually during initiation:
my $call = $wsdl->compileClient('GetTaxHistory');
# ... then call it as often as you need.
# The details of the types and elements are attached below.

# Header part 'Profile' is element tns:Profile
my $Profile = {};

# Header part 'wsse_Security' is element wsse:Security
my $wsse_Security = {};

# Body part 'parameters' is element tns:GetTaxHistory
my $parameters = {};

# Call with the combination of parts.
my @params = (
    Profile => $Profile,
    wsse_Security => $wsse_Security,
    parameters => $parameters,
);
my ($answer, $trace) = $call->(@params);

# @params will become %$data_in in the server handler.
# $answer is a HASH, an operation OUTPUT or Fault.
# $trace is an XML::Compile::SOAP::Trace object.

# You may get an error back from the server
if(my $f = $answer->{Fault})
{   my $errname = $f->{_NAME};
    my $error   = $answer->{$errname};
    print "$error->{code}\n";

    my $details = $error->{detail};
    if(not $details)
    {   # system error, no $details
    }
    exit 1;
}

#--------------------------------------------------------------
$Profile =
# Describing complex tns:Profile
#     {http://avatax.avalara.com/services}Profile
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:xs        http://www.w3.org/2001/XMLSchema

# is a tns:Profile
{ # any attribute in any namespace
  ANYATTR => "AnySimple",

  # sequence of Name, Client, Adapter, Machine

  # is a xs:string
  # is optional
  Name => "example",

  # is a xs:string
  # is optional
  Client => "example",

  # is a xs:string
  # is optional
  Adapter => "example",

  # is a xs:string
  # is optional
  Machine => "example", }

;

#--------------------------------------------------------------
$wsse_Security =
# Describing complex wsse:Security
#     {http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd}Security
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:wsse      http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd
# xmlns:xs        http://www.w3.org/2001/XMLSchema

# is a wsse:SecurityHeaderType
{ # any attribute not in wsse:
  ANYATTR => "AnySimple",

  # sequence of ANY

  # any element in any namespace
  # occurs any number of times
  ANY => [ "Anything", ], }

;

#--------------------------------------------------------------
$parameters =
# Describing complex tns:GetTaxHistory
#     {http://avatax.avalara.com/services}GetTaxHistory
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:wsse      http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd

# is an unnamed complex
{ # sequence of GetTaxHistoryRequest

  # is a tns:GetTaxHistoryRequest
  # is optional
  GetTaxHistoryRequest =>
  { # sequence of DocId, CompanyCode, DocType, DocCode, DetailLevel

    # is a xs:string
    # is optional
    DocId => "example",

    # is a xs:string
    # is optional
    CompanyCode => "example",

    # is a xs:string
    # Enum: InventoryTransferInvoice InventoryTransferOrder
    #    PurchaseInvoice PurchaseOrder ReturnInvoice
    #    ReturnOrder ReverseChargeInvoice ReverseChargeOrder
    #    SalesInvoice SalesOrder
    DocType => "SalesOrder",

    # is a xs:string
    # is optional
    DocCode => "example",

    # is a xs:string
    # Enum: Diagnostic Document Line Summary Tax
    DetailLevel => "Document", }, }

;

# Operation PostTaxSoapIn
#           INPUT, document literal
# Produced  by XML::Compile::SOAP12::Operation version 3.03
#           on Wed Mar 11 15:25:00 2015
#
# The output below is only an example: it cannot be used
# without interpretation, although very close to real code.

# Compile only once in your code, usually during initiation:
my $call = $wsdl->compileClient('PostTax');
# ... then call it as often as you need.
# The details of the types and elements are attached below.

# Header part 'Profile' is element tns:Profile
my $Profile = {};

# Header part 'wsse_Security' is element wsse:Security
my $wsse_Security = {};

# Body part 'parameters' is element tns:PostTax
my $parameters = {};

# Call with the combination of parts.
my @params = (
    Profile => $Profile,
    wsse_Security => $wsse_Security,
    parameters => $parameters,
);
my ($answer, $trace) = $call->(@params);

# @params will become %$data_in in the server handler.
# $answer is a HASH, an operation OUTPUT or Fault.
# $trace is an XML::Compile::SOAP::Trace object.

# You may get an error back from the server
if(my $f = $answer->{Fault})
{   my $errname = $f->{_NAME};
    my $error   = $answer->{$errname};
    print "$error->{code}\n";

    my $details = $error->{detail};
    if(not $details)
    {   # system error, no $details
    }
    exit 1;
}

#--------------------------------------------------------------
$Profile =
# Describing complex tns:Profile
#     {http://avatax.avalara.com/services}Profile
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:xs        http://www.w3.org/2001/XMLSchema

# is a tns:Profile
{ # any attribute in any namespace
  ANYATTR => "AnySimple",

  # sequence of Name, Client, Adapter, Machine

  # is a xs:string
  # is optional
  Name => "example",

  # is a xs:string
  # is optional
  Client => "example",

  # is a xs:string
  # is optional
  Adapter => "example",

  # is a xs:string
  # is optional
  Machine => "example", }

;

#--------------------------------------------------------------
$wsse_Security =
# Describing complex wsse:Security
#     {http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd}Security
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:wsse      http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd
# xmlns:xs        http://www.w3.org/2001/XMLSchema

# is a wsse:SecurityHeaderType
{ # any attribute not in wsse:
  ANYATTR => "AnySimple",

  # sequence of ANY

  # any element in any namespace
  # occurs any number of times
  ANY => [ "Anything", ], }

;

#--------------------------------------------------------------
$parameters =
# Describing complex tns:PostTax
#     {http://avatax.avalara.com/services}PostTax
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:wsse      http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd

# is an unnamed complex
{ # sequence of PostTaxRequest

  # is a tns:PostTaxRequest
  # is optional
  PostTaxRequest =>
  { # sequence of DocId, CompanyCode, DocType, DocCode, DocDate,
    #   TotalAmount, TotalTax, HashCode, Commit, NewDocCode

    # is a xs:string
    # is optional
    DocId => "example",

    # is a xs:string
    # is optional
    CompanyCode => "example",

    # is a xs:string
    # Enum: InventoryTransferInvoice InventoryTransferOrder
    #    PurchaseInvoice PurchaseOrder ReturnInvoice
    #    ReturnOrder ReverseChargeInvoice ReverseChargeOrder
    #    SalesInvoice SalesOrder
    DocType => "SalesOrder",

    # is a xs:string
    # is optional
    DocCode => "example",

    # is a xs:date
    DocDate => "2006-10-06",

    # is a xs:decimal
    TotalAmount => 3.1415,

    # is a xs:decimal
    TotalTax => 3.1415,

    # is a xs:int
    HashCode => 42,

    # is a xs:boolean
    Commit => "true",

    # is a xs:string
    # is optional
    NewDocCode => "example", }, }

;

# Operation CommitTaxSoapIn
#           INPUT, document literal
# Produced  by XML::Compile::SOAP12::Operation version 3.03
#           on Wed Mar 11 15:25:00 2015
#
# The output below is only an example: it cannot be used
# without interpretation, although very close to real code.

# Compile only once in your code, usually during initiation:
my $call = $wsdl->compileClient('CommitTax');
# ... then call it as often as you need.
# The details of the types and elements are attached below.

# Header part 'AuditMessage' is element tns:AuditMessage
my $AuditMessage = {};

# Header part 'Profile' is element tns:Profile
my $Profile = {};

# Header part 'wsse_Security' is element wsse:Security
my $wsse_Security = {};

# Body part 'parameters' is element tns:CommitTax
my $parameters = {};

# Call with the combination of parts.
my @params = (
    AuditMessage => $AuditMessage,
    Profile => $Profile,
    wsse_Security => $wsse_Security,
    parameters => $parameters,
);
my ($answer, $trace) = $call->(@params);

# @params will become %$data_in in the server handler.
# $answer is a HASH, an operation OUTPUT or Fault.
# $trace is an XML::Compile::SOAP::Trace object.

# You may get an error back from the server
if(my $f = $answer->{Fault})
{   my $errname = $f->{_NAME};
    my $error   = $answer->{$errname};
    print "$error->{code}\n";

    my $details = $error->{detail};
    if(not $details)
    {   # system error, no $details
    }
    exit 1;
}

#--------------------------------------------------------------
$AuditMessage =
# Describing complex tns:AuditMessage
#     {http://avatax.avalara.com/services}AuditMessage
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:xs        http://www.w3.org/2001/XMLSchema

# is a tns:AuditMessage
{ # any attribute in any namespace
  ANYATTR => "AnySimple",

  # sequence of Message

  # is a xs:string
  # is optional
  Message => "example", }

;

#--------------------------------------------------------------
$Profile =
# Describing complex tns:Profile
#     {http://avatax.avalara.com/services}Profile
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:xs        http://www.w3.org/2001/XMLSchema

# is a tns:Profile
{ # any attribute in any namespace
  ANYATTR => "AnySimple",

  # sequence of Name, Client, Adapter, Machine

  # is a xs:string
  # is optional
  Name => "example",

  # is a xs:string
  # is optional
  Client => "example",

  # is a xs:string
  # is optional
  Adapter => "example",

  # is a xs:string
  # is optional
  Machine => "example", }

;

#--------------------------------------------------------------
$wsse_Security =
# Describing complex wsse:Security
#     {http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd}Security
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:wsse      http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd
# xmlns:xs        http://www.w3.org/2001/XMLSchema

# is a wsse:SecurityHeaderType
{ # any attribute not in wsse:
  ANYATTR => "AnySimple",

  # sequence of ANY

  # any element in any namespace
  # occurs any number of times
  ANY => [ "Anything", ], }

;

#--------------------------------------------------------------
$parameters =
# Describing complex tns:CommitTax
#     {http://avatax.avalara.com/services}CommitTax
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:wsse      http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd

# is an unnamed complex
{ # sequence of CommitTaxRequest

  # is a tns:CommitTaxRequest
  # is optional
  CommitTaxRequest =>
  { # sequence of DocId, CompanyCode, DocType, DocCode, NewDocCode

    # is a xs:string
    # is optional
    DocId => "example",

    # is a xs:string
    # is optional
    CompanyCode => "example",

    # is a xs:string
    # Enum: InventoryTransferInvoice InventoryTransferOrder
    #    PurchaseInvoice PurchaseOrder ReturnInvoice
    #    ReturnOrder ReverseChargeInvoice ReverseChargeOrder
    #    SalesInvoice SalesOrder
    DocType => "SalesOrder",

    # is a xs:string
    # is optional
    DocCode => "example",

    # is a xs:string
    # is optional
    NewDocCode => "example", }, }

;

# Operation CancelTaxSoapIn
#           INPUT, document literal
# Produced  by XML::Compile::SOAP12::Operation version 3.03
#           on Wed Mar 11 15:25:00 2015
#
# The output below is only an example: it cannot be used
# without interpretation, although very close to real code.

# Compile only once in your code, usually during initiation:
my $call = $wsdl->compileClient('CancelTax');
# ... then call it as often as you need.
# The details of the types and elements are attached below.

# Header part 'AuditMessage' is element tns:AuditMessage
my $AuditMessage = {};

# Header part 'Profile' is element tns:Profile
my $Profile = {};

# Header part 'wsse_Security' is element wsse:Security
my $wsse_Security = {};

# Body part 'parameters' is element tns:CancelTax
my $parameters = {};

# Call with the combination of parts.
my @params = (
    AuditMessage => $AuditMessage,
    Profile => $Profile,
    wsse_Security => $wsse_Security,
    parameters => $parameters,
);
my ($answer, $trace) = $call->(@params);

# @params will become %$data_in in the server handler.
# $answer is a HASH, an operation OUTPUT or Fault.
# $trace is an XML::Compile::SOAP::Trace object.

# You may get an error back from the server
if(my $f = $answer->{Fault})
{   my $errname = $f->{_NAME};
    my $error   = $answer->{$errname};
    print "$error->{code}\n";

    my $details = $error->{detail};
    if(not $details)
    {   # system error, no $details
    }
    exit 1;
}

#--------------------------------------------------------------
$AuditMessage =
# Describing complex tns:AuditMessage
#     {http://avatax.avalara.com/services}AuditMessage
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:xs        http://www.w3.org/2001/XMLSchema

# is a tns:AuditMessage
{ # any attribute in any namespace
  ANYATTR => "AnySimple",

  # sequence of Message

  # is a xs:string
  # is optional
  Message => "example", }

;

#--------------------------------------------------------------
$Profile =
# Describing complex tns:Profile
#     {http://avatax.avalara.com/services}Profile
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:xs        http://www.w3.org/2001/XMLSchema

# is a tns:Profile
{ # any attribute in any namespace
  ANYATTR => "AnySimple",

  # sequence of Name, Client, Adapter, Machine

  # is a xs:string
  # is optional
  Name => "example",

  # is a xs:string
  # is optional
  Client => "example",

  # is a xs:string
  # is optional
  Adapter => "example",

  # is a xs:string
  # is optional
  Machine => "example", }

;

#--------------------------------------------------------------
$wsse_Security =
# Describing complex wsse:Security
#     {http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd}Security
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:wsse      http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd
# xmlns:xs        http://www.w3.org/2001/XMLSchema

# is a wsse:SecurityHeaderType
{ # any attribute not in wsse:
  ANYATTR => "AnySimple",

  # sequence of ANY

  # any element in any namespace
  # occurs any number of times
  ANY => [ "Anything", ], }

;

#--------------------------------------------------------------
$parameters =
# Describing complex tns:CancelTax
#     {http://avatax.avalara.com/services}CancelTax
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:wsse      http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd

# is an unnamed complex
{ # sequence of CancelTaxRequest

  # is a tns:CancelTaxRequest
  # is optional
  CancelTaxRequest =>
  { # sequence of DocId, CompanyCode, DocType, DocCode, CancelCode

    # is a xs:string
    # is optional
    DocId => "example",

    # is a xs:string
    # is optional
    CompanyCode => "example",

    # is a xs:string
    # Enum: InventoryTransferInvoice InventoryTransferOrder
    #    PurchaseInvoice PurchaseOrder ReturnInvoice
    #    ReturnOrder ReverseChargeInvoice ReverseChargeOrder
    #    SalesInvoice SalesOrder
    DocType => "SalesOrder",

    # is a xs:string
    # is optional
    DocCode => "example",

    # is a xs:string
    # Enum: AdjustmentCancelled DocDeleted DocVoided
    #    PostFailed Unspecified
    CancelCode => "Unspecified", }, }

;

# Operation ReconcileTaxHistorySoapIn
#           INPUT, document literal
# Produced  by XML::Compile::SOAP12::Operation version 3.03
#           on Wed Mar 11 15:25:00 2015
#
# The output below is only an example: it cannot be used
# without interpretation, although very close to real code.

# Compile only once in your code, usually during initiation:
my $call = $wsdl->compileClient('ReconcileTaxHistory');
# ... then call it as often as you need.
# The details of the types and elements are attached below.

# Header part 'Profile' is element tns:Profile
my $Profile = {};

# Header part 'wsse_Security' is element wsse:Security
my $wsse_Security = {};

# Body part 'parameters' is element tns:ReconcileTaxHistory
my $parameters = {};

# Call with the combination of parts.
my @params = (
    Profile => $Profile,
    wsse_Security => $wsse_Security,
    parameters => $parameters,
);
my ($answer, $trace) = $call->(@params);

# @params will become %$data_in in the server handler.
# $answer is a HASH, an operation OUTPUT or Fault.
# $trace is an XML::Compile::SOAP::Trace object.

# You may get an error back from the server
if(my $f = $answer->{Fault})
{   my $errname = $f->{_NAME};
    my $error   = $answer->{$errname};
    print "$error->{code}\n";

    my $details = $error->{detail};
    if(not $details)
    {   # system error, no $details
    }
    exit 1;
}

#--------------------------------------------------------------
$Profile =
# Describing complex tns:Profile
#     {http://avatax.avalara.com/services}Profile
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:xs        http://www.w3.org/2001/XMLSchema

# is a tns:Profile
{ # any attribute in any namespace
  ANYATTR => "AnySimple",

  # sequence of Name, Client, Adapter, Machine

  # is a xs:string
  # is optional
  Name => "example",

  # is a xs:string
  # is optional
  Client => "example",

  # is a xs:string
  # is optional
  Adapter => "example",

  # is a xs:string
  # is optional
  Machine => "example", }

;

#--------------------------------------------------------------
$wsse_Security =
# Describing complex wsse:Security
#     {http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd}Security
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:wsse      http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd
# xmlns:xs        http://www.w3.org/2001/XMLSchema

# is a wsse:SecurityHeaderType
{ # any attribute not in wsse:
  ANYATTR => "AnySimple",

  # sequence of ANY

  # any element in any namespace
  # occurs any number of times
  ANY => [ "Anything", ], }

;

#--------------------------------------------------------------
$parameters =
# Describing complex tns:ReconcileTaxHistory
#     {http://avatax.avalara.com/services}ReconcileTaxHistory
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:wsse      http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd

# is an unnamed complex
{ # sequence of ReconcileTaxHistoryRequest

  # is a tns:ReconcileTaxHistoryRequest
  # is optional
  ReconcileTaxHistoryRequest =>
  { # sequence of CompanyCode, LastDocId, Reconciled, StartDate,
    #   EndDate, DocStatus, DocType, LastDocCode, PageSize

    # is a xs:string
    # is optional
    CompanyCode => "example",

    # is a xs:string
    # is optional
    LastDocId => "example",

    # is a xs:boolean
    Reconciled => "true",

    # is a xs:date
    StartDate => "2006-10-06",

    # is a xs:date
    EndDate => "2006-10-06",

    # is a xs:string
    # Enum: Adjusted Any Cancelled Committed Posted Saved
    #    Temporary
    DocStatus => "Temporary",

    # is a xs:string
    # Enum: InventoryTransferInvoice InventoryTransferOrder
    #    PurchaseInvoice PurchaseOrder ReturnInvoice
    #    ReturnOrder ReverseChargeInvoice ReverseChargeOrder
    #    SalesInvoice SalesOrder
    DocType => "SalesOrder",

    # is a xs:string
    LastDocCode => "example",

    # is a xs:int
    PageSize => 42, }, }

;

# Operation AdjustTaxSoapIn
#           INPUT, document literal
# Produced  by XML::Compile::SOAP12::Operation version 3.03
#           on Wed Mar 11 15:25:00 2015
#
# The output below is only an example: it cannot be used
# without interpretation, although very close to real code.

# Compile only once in your code, usually during initiation:
my $call = $wsdl->compileClient('AdjustTax');
# ... then call it as often as you need.
# The details of the types and elements are attached below.

# Header part 'Profile' is element tns:Profile
my $Profile = {};

# Header part 'wsse_Security' is element wsse:Security
my $wsse_Security = {};

# Body part 'parameters' is element tns:AdjustTax
my $parameters = {};

# Call with the combination of parts.
my @params = (
    Profile => $Profile,
    wsse_Security => $wsse_Security,
    parameters => $parameters,
);
my ($answer, $trace) = $call->(@params);

# @params will become %$data_in in the server handler.
# $answer is a HASH, an operation OUTPUT or Fault.
# $trace is an XML::Compile::SOAP::Trace object.

# You may get an error back from the server
if(my $f = $answer->{Fault})
{   my $errname = $f->{_NAME};
    my $error   = $answer->{$errname};
    print "$error->{code}\n";

    my $details = $error->{detail};
    if(not $details)
    {   # system error, no $details
    }
    exit 1;
}

#--------------------------------------------------------------
$Profile =
# Describing complex tns:Profile
#     {http://avatax.avalara.com/services}Profile
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:xs        http://www.w3.org/2001/XMLSchema

# is a tns:Profile
{ # any attribute in any namespace
  ANYATTR => "AnySimple",

  # sequence of Name, Client, Adapter, Machine

  # is a xs:string
  # is optional
  Name => "example",

  # is a xs:string
  # is optional
  Client => "example",

  # is a xs:string
  # is optional
  Adapter => "example",

  # is a xs:string
  # is optional
  Machine => "example", }

;

#--------------------------------------------------------------
$wsse_Security =
# Describing complex wsse:Security
#     {http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd}Security
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:wsse      http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd
# xmlns:xs        http://www.w3.org/2001/XMLSchema

# is a wsse:SecurityHeaderType
{ # any attribute not in wsse:
  ANYATTR => "AnySimple",

  # sequence of ANY

  # any element in any namespace
  # occurs any number of times
  ANY => [ "Anything", ], }

;

#--------------------------------------------------------------
$parameters =
# Describing complex tns:AdjustTax
#     {http://avatax.avalara.com/services}AdjustTax
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:wsse      http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd

# is an unnamed complex
{ # sequence of AdjustTaxRequest

  # is a tns:AdjustTaxRequest
  # is optional
  AdjustTaxRequest =>
  { # sequence of AdjustmentReason, AdjustmentDescription,
    #   GetTaxRequest

    # is a xs:int
    AdjustmentReason => 42,

    # is a xs:string
    # is optional
    AdjustmentDescription => "example",

    # is a tns:GetTaxRequest
    # is optional
    GetTaxRequest =>
    { # sequence of CompanyCode, DocType, DocCode, DocDate,
      #   SalespersonCode, CustomerCode, CustomerUsageType, Discount,
      #   PurchaseOrderNo, ExemptionNo, OriginCode, DestinationCode,
      #   Addresses, Lines, DetailLevel, ReferenceCode, HashCode,
      #   LocationCode, Commit, BatchCode, TaxOverride, CurrencyCode,
      #   ServiceMode, PaymentDate, ExchangeRate, ExchangeRateEffDate,
      #   PosLaneCode, BusinessIdentificationNo

      # is a xs:string
      # is optional
      CompanyCode => "example",

      # is a xs:string
      # Enum: InventoryTransferInvoice InventoryTransferOrder
      #    PurchaseInvoice PurchaseOrder ReturnInvoice
      #    ReturnOrder ReverseChargeInvoice ReverseChargeOrder
      #    SalesInvoice SalesOrder
      DocType => "SalesOrder",

      # is a xs:string
      # is optional
      DocCode => "example",

      # is a xs:date
      DocDate => "2006-10-06",

      # is a xs:string
      # is optional
      SalespersonCode => "example",

      # is a xs:string
      # is optional
      CustomerCode => "example",

      # is a xs:string
      # is optional
      CustomerUsageType => "example",

      # is a xs:decimal
      Discount => 3.1415,

      # is a xs:string
      # is optional
      PurchaseOrderNo => "example",

      # is a xs:string
      # is optional
      ExemptionNo => "example",

      # is a xs:string
      # is optional
      OriginCode => "example",

      # is a xs:string
      # is optional
      DestinationCode => "example",

      # is a tns:ArrayOfBaseAddress
      # is optional
      Addresses =>
      { # sequence of BaseAddress

        # is a tns:BaseAddress
        # is nillable, as: BaseAddress => NIL
        # occurs any number of times
        BaseAddress =>
        [ { # sequence of AddressCode, Line1, Line2, Line3, City, Region,
            #   PostalCode, Country, TaxRegionId, Latitude, Longitude

            # is a xs:string
            # is optional
            AddressCode => "example",

            # is a xs:string
            # is optional
            Line1 => "example",

            # is a xs:string
            # is optional
            Line2 => "example",

            # is a xs:string
            # is optional
            Line3 => "example",

            # is a xs:string
            # is optional
            City => "example",

            # is a xs:string
            # is optional
            Region => "example",

            # is a xs:string
            # is optional
            PostalCode => "example",

            # is a xs:string
            # is optional
            Country => "example",

            # is a xs:int
            TaxRegionId => 42,

            # is a xs:string
            # is optional
            Latitude => "example",

            # is a xs:string
            # is optional
            Longitude => "example", }, ], },

      # is a tns:ArrayOfLine
      # is optional
      Lines =>
      { # sequence of Line

        # is a tns:Line
        # is nillable, as: Line => NIL
        # occurs any number of times
        Line =>
        [ { # sequence of No, OriginCode, DestinationCode, ItemCode,
            #   TaxCode, Qty, Amount, Discounted, RevAcct, Ref1, Ref2,
            #   ExemptionNo, CustomerUsageType, Description, TaxOverride,
            #   TaxIncluded, BusinessIdentificationNo

            # is a xs:string
            # is optional
            No => "example",

            # is a xs:string
            # is optional
            OriginCode => "example",

            # is a xs:string
            # is optional
            DestinationCode => "example",

            # is a xs:string
            # is optional
            ItemCode => "example",

            # is a xs:string
            # is optional
            TaxCode => "example",

            # is a xs:decimal
            Qty => 3.1415,

            # is a xs:decimal
            Amount => 3.1415,

            # is a xs:boolean
            Discounted => "true",

            # is a xs:string
            # is optional
            RevAcct => "example",

            # is a xs:string
            # is optional
            Ref1 => "example",

            # is a xs:string
            # is optional
            Ref2 => "example",

            # is a xs:string
            # is optional
            ExemptionNo => "example",

            # is a xs:string
            # is optional
            CustomerUsageType => "example",

            # is a xs:string
            # is optional
            Description => "example",

            # is a tns:TaxOverride
            # is optional
            TaxOverride =>
            { # sequence of TaxOverrideType, TaxAmount, TaxDate, Reason

              # is a xs:string
              # Enum: AccruedTaxAmount DeriveTaxable Exemption None
              #    TaxAmount TaxDate
              TaxOverrideType => "None",

              # is a xs:decimal
              TaxAmount => 3.1415,

              # is a xs:date
              TaxDate => "2006-10-06",

              # is a xs:string
              # is optional
              Reason => "example", },

            # is a xs:boolean
            # defaults to 'false'
            TaxIncluded => "false",

            # is a xs:string
            # is optional
            BusinessIdentificationNo => "example", }, ], },

      # is a xs:string
      # Enum: Diagnostic Document Line Summary Tax
      DetailLevel => "Document",

      # is a xs:string
      # is optional
      ReferenceCode => "example",

      # is a xs:int
      HashCode => 42,

      # is a xs:string
      # is optional
      LocationCode => "example",

      # is a xs:boolean
      Commit => "true",

      # is a xs:string
      # is optional
      BatchCode => "example",

      # is a tns:TaxOverride
      # complex structure shown above
      # is optional
      TaxOverride => [{},],

      # is a xs:string
      # is optional
      CurrencyCode => "example",

      # is a xs:string
      # Enum: Automatic Local Remote
      ServiceMode => "Automatic",

      # is a xs:date
      PaymentDate => "2006-10-06",

      # is a xs:decimal
      ExchangeRate => 3.1415,

      # is a xs:date
      ExchangeRateEffDate => "2006-10-06",

      # is a xs:string
      # is optional
      PosLaneCode => "example",

      # is a xs:string
      # is optional
      BusinessIdentificationNo => "example", }, }, }

;

# Operation ApplyPaymentSoapIn
#           INPUT, document literal
# Produced  by XML::Compile::SOAP12::Operation version 3.03
#           on Wed Mar 11 15:25:00 2015
#
# The output below is only an example: it cannot be used
# without interpretation, although very close to real code.

# Compile only once in your code, usually during initiation:
my $call = $wsdl->compileClient('ApplyPayment');
# ... then call it as often as you need.
# The details of the types and elements are attached below.

# Header part 'AuditMessage' is element tns:AuditMessage
my $AuditMessage = {};

# Header part 'Profile' is element tns:Profile
my $Profile = {};

# Header part 'wsse_Security' is element wsse:Security
my $wsse_Security = {};

# Body part 'parameters' is element tns:ApplyPayment
my $parameters = {};

# Call with the combination of parts.
my @params = (
    AuditMessage => $AuditMessage,
    Profile => $Profile,
    wsse_Security => $wsse_Security,
    parameters => $parameters,
);
my ($answer, $trace) = $call->(@params);

# @params will become %$data_in in the server handler.
# $answer is a HASH, an operation OUTPUT or Fault.
# $trace is an XML::Compile::SOAP::Trace object.

# You may get an error back from the server
if(my $f = $answer->{Fault})
{   my $errname = $f->{_NAME};
    my $error   = $answer->{$errname};
    print "$error->{code}\n";

    my $details = $error->{detail};
    if(not $details)
    {   # system error, no $details
    }
    exit 1;
}

#--------------------------------------------------------------
$AuditMessage =
# Describing complex tns:AuditMessage
#     {http://avatax.avalara.com/services}AuditMessage
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:xs        http://www.w3.org/2001/XMLSchema

# is a tns:AuditMessage
{ # any attribute in any namespace
  ANYATTR => "AnySimple",

  # sequence of Message

  # is a xs:string
  # is optional
  Message => "example", }

;

#--------------------------------------------------------------
$Profile =
# Describing complex tns:Profile
#     {http://avatax.avalara.com/services}Profile
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:xs        http://www.w3.org/2001/XMLSchema

# is a tns:Profile
{ # any attribute in any namespace
  ANYATTR => "AnySimple",

  # sequence of Name, Client, Adapter, Machine

  # is a xs:string
  # is optional
  Name => "example",

  # is a xs:string
  # is optional
  Client => "example",

  # is a xs:string
  # is optional
  Adapter => "example",

  # is a xs:string
  # is optional
  Machine => "example", }

;

#--------------------------------------------------------------
$wsse_Security =
# Describing complex wsse:Security
#     {http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd}Security
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:wsse      http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd
# xmlns:xs        http://www.w3.org/2001/XMLSchema

# is a wsse:SecurityHeaderType
{ # any attribute not in wsse:
  ANYATTR => "AnySimple",

  # sequence of ANY

  # any element in any namespace
  # occurs any number of times
  ANY => [ "Anything", ], }

;

#--------------------------------------------------------------
$parameters =
# Describing complex tns:ApplyPayment
#     {http://avatax.avalara.com/services}ApplyPayment
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:wsse      http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd

# is an unnamed complex
{ # sequence of ApplyPaymentRequest

  # is a tns:ApplyPaymentRequest
  # is optional
  ApplyPaymentRequest =>
  { # sequence of DocId, CompanyCode, DocType, DocCode, PaymentDate

    # is a xs:string
    # is optional
    DocId => "example",

    # is a xs:string
    # is optional
    CompanyCode => "example",

    # is a xs:string
    # Enum: InventoryTransferInvoice InventoryTransferOrder
    #    PurchaseInvoice PurchaseOrder ReturnInvoice
    #    ReturnOrder ReverseChargeInvoice ReverseChargeOrder
    #    SalesInvoice SalesOrder
    DocType => "SalesOrder",

    # is a xs:string
    # is optional
    DocCode => "example",

    # is a xs:date
    PaymentDate => "2006-10-06", }, }

;

# Operation PingSoapIn
#           INPUT, document literal
# Produced  by XML::Compile::SOAP12::Operation version 3.03
#           on Wed Mar 11 15:25:00 2015
#
# The output below is only an example: it cannot be used
# without interpretation, although very close to real code.

# Compile only once in your code, usually during initiation:
my $call = $wsdl->compileClient('Ping');
# ... then call it as often as you need.
# The details of the types and elements are attached below.

# Header part 'Profile' is element tns:Profile
my $Profile = {};

# Header part 'wsse_Security' is element wsse:Security
my $wsse_Security = {};

# Body part 'parameters' is element tns:Ping
my $parameters = {};

# Call with the combination of parts.
my @params = (
    Profile => $Profile,
    wsse_Security => $wsse_Security,
    parameters => $parameters,
);
my ($answer, $trace) = $call->(@params);

# @params will become %$data_in in the server handler.
# $answer is a HASH, an operation OUTPUT or Fault.
# $trace is an XML::Compile::SOAP::Trace object.

# You may get an error back from the server
if(my $f = $answer->{Fault})
{   my $errname = $f->{_NAME};
    my $error   = $answer->{$errname};
    print "$error->{code}\n";

    my $details = $error->{detail};
    if(not $details)
    {   # system error, no $details
    }
    exit 1;
}

#--------------------------------------------------------------
$Profile =
# Describing complex tns:Profile
#     {http://avatax.avalara.com/services}Profile
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:xs        http://www.w3.org/2001/XMLSchema

# is a tns:Profile
{ # any attribute in any namespace
  ANYATTR => "AnySimple",

  # sequence of Name, Client, Adapter, Machine

  # is a xs:string
  # is optional
  Name => "example",

  # is a xs:string
  # is optional
  Client => "example",

  # is a xs:string
  # is optional
  Adapter => "example",

  # is a xs:string
  # is optional
  Machine => "example", }

;

#--------------------------------------------------------------
$wsse_Security =
# Describing complex wsse:Security
#     {http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd}Security
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:wsse      http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd
# xmlns:xs        http://www.w3.org/2001/XMLSchema

# is a wsse:SecurityHeaderType
{ # any attribute not in wsse:
  ANYATTR => "AnySimple",

  # sequence of ANY

  # any element in any namespace
  # occurs any number of times
  ANY => [ "Anything", ], }

;

#--------------------------------------------------------------
$parameters =
# Describing complex tns:Ping
#     {http://avatax.avalara.com/services}Ping
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:wsse      http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd

# is an unnamed complex
{ # sequence of Message

  # is a xs:string
  # is optional
  Message => "example", }

;

# Operation IsAuthorizedSoapIn
#           INPUT, document literal
# Produced  by XML::Compile::SOAP12::Operation version 3.03
#           on Wed Mar 11 15:25:00 2015
#
# The output below is only an example: it cannot be used
# without interpretation, although very close to real code.

# Compile only once in your code, usually during initiation:
my $call = $wsdl->compileClient('IsAuthorized');
# ... then call it as often as you need.
# The details of the types and elements are attached below.

# Header part 'Profile' is element tns:Profile
my $Profile = {};

# Header part 'wsse_Security' is element wsse:Security
my $wsse_Security = {};

# Body part 'parameters' is element tns:IsAuthorized
my $parameters = {};

# Call with the combination of parts.
my @params = (
    Profile => $Profile,
    wsse_Security => $wsse_Security,
    parameters => $parameters,
);
my ($answer, $trace) = $call->(@params);

# @params will become %$data_in in the server handler.
# $answer is a HASH, an operation OUTPUT or Fault.
# $trace is an XML::Compile::SOAP::Trace object.

# You may get an error back from the server
if(my $f = $answer->{Fault})
{   my $errname = $f->{_NAME};
    my $error   = $answer->{$errname};
    print "$error->{code}\n";

    my $details = $error->{detail};
    if(not $details)
    {   # system error, no $details
    }
    exit 1;
}

#--------------------------------------------------------------
$Profile =
# Describing complex tns:Profile
#     {http://avatax.avalara.com/services}Profile
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:xs        http://www.w3.org/2001/XMLSchema

# is a tns:Profile
{ # any attribute in any namespace
  ANYATTR => "AnySimple",

  # sequence of Name, Client, Adapter, Machine

  # is a xs:string
  # is optional
  Name => "example",

  # is a xs:string
  # is optional
  Client => "example",

  # is a xs:string
  # is optional
  Adapter => "example",

  # is a xs:string
  # is optional
  Machine => "example", }

;

#--------------------------------------------------------------
$wsse_Security =
# Describing complex wsse:Security
#     {http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd}Security
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:wsse      http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd
# xmlns:xs        http://www.w3.org/2001/XMLSchema

# is a wsse:SecurityHeaderType
{ # any attribute not in wsse:
  ANYATTR => "AnySimple",

  # sequence of ANY

  # any element in any namespace
  # occurs any number of times
  ANY => [ "Anything", ], }

;

#--------------------------------------------------------------
$parameters =
# Describing complex tns:IsAuthorized
#     {http://avatax.avalara.com/services}IsAuthorized
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:wsse      http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd

# is an unnamed complex
{ # sequence of Operations

  # is a xs:string
  # is optional
  Operations => "example", }

;

# Operation TaxSummaryFetchSoapIn
#           INPUT, document literal
# Produced  by XML::Compile::SOAP12::Operation version 3.03
#           on Wed Mar 11 15:25:00 2015
#
# The output below is only an example: it cannot be used
# without interpretation, although very close to real code.

# Compile only once in your code, usually during initiation:
my $call = $wsdl->compileClient('TaxSummaryFetch');
# ... then call it as often as you need.
# The details of the types and elements are attached below.

# Header part 'Profile' is element tns:Profile
my $Profile = {};

# Header part 'wsse_Security' is element wsse:Security
my $wsse_Security = {};

# Body part 'parameters' is element tns:TaxSummaryFetch
my $parameters = {};

# Call with the combination of parts.
my @params = (
    Profile => $Profile,
    wsse_Security => $wsse_Security,
    parameters => $parameters,
);
my ($answer, $trace) = $call->(@params);

# @params will become %$data_in in the server handler.
# $answer is a HASH, an operation OUTPUT or Fault.
# $trace is an XML::Compile::SOAP::Trace object.

# You may get an error back from the server
if(my $f = $answer->{Fault})
{   my $errname = $f->{_NAME};
    my $error   = $answer->{$errname};
    print "$error->{code}\n";

    my $details = $error->{detail};
    if(not $details)
    {   # system error, no $details
    }
    exit 1;
}

#--------------------------------------------------------------
$Profile =
# Describing complex tns:Profile
#     {http://avatax.avalara.com/services}Profile
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:xs        http://www.w3.org/2001/XMLSchema

# is a tns:Profile
{ # any attribute in any namespace
  ANYATTR => "AnySimple",

  # sequence of Name, Client, Adapter, Machine

  # is a xs:string
  # is optional
  Name => "example",

  # is a xs:string
  # is optional
  Client => "example",

  # is a xs:string
  # is optional
  Adapter => "example",

  # is a xs:string
  # is optional
  Machine => "example", }

;

#--------------------------------------------------------------
$wsse_Security =
# Describing complex wsse:Security
#     {http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd}Security
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:wsse      http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd
# xmlns:xs        http://www.w3.org/2001/XMLSchema

# is a wsse:SecurityHeaderType
{ # any attribute not in wsse:
  ANYATTR => "AnySimple",

  # sequence of ANY

  # any element in any namespace
  # occurs any number of times
  ANY => [ "Anything", ], }

;

#--------------------------------------------------------------
$parameters =
# Describing complex tns:TaxSummaryFetch
#     {http://avatax.avalara.com/services}TaxSummaryFetch
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:wsse      http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd

# is an unnamed complex
{ # sequence of TaxSummaryFetchRequest

  # is a tns:TaxSummaryFetchRequest
  # is optional
  TaxSummaryFetchRequest =>
  { # sequence of MerchantCode, StartDate, EndDate

    # is a xs:string
    # is optional
    MerchantCode => "example",

    # is a xs:date
    StartDate => "2006-10-06",

    # is a xs:date
    EndDate => "2006-10-06", }, }

;

# Operation ValidateSoapIn
#           INPUT, document literal
# Produced  by XML::Compile::SOAP11::Operation version 3.08
#           on Wed Mar 11 15:25:00 2015
#
# The output below is only an example: it cannot be used
# without interpretation, although very close to real code.

# Compile only once in your code, usually during initiation:
#   my $call = $wsdl->compileClient('Validate');
# then call it as often as you need.  Alternatively
#   $wsdl->compileCalls();   # once
#   $response = $wsdl->call('Validate', $request);
# The details of the types and elements are attached below.

# Header part 'Profile' is element tns:Profile
my $Profile = {};

# Header part 'wsse_Security' is element wsse:Security
my $wsse_Security = {};

# Body part 'parameters' is element tns:Validate
my $parameters = {};

# Call with the combination of parts.
my @params = (
    Profile => $Profile,
    wsse_Security => $wsse_Security,
    parameters => $parameters,
);
my ($answer, $trace) = $call->(@params);

# @params will become %$data_in in the server handler.
# $answer is a HASH, an operation OUTPUT or Fault.
# $trace is an XML::Compile::SOAP::Trace object.

# You may get an error back from the server
if(my $f = $answer->{Fault})
{   my $errname = $f->{_NAME};
    my $error   = $answer->{$errname};
    print "$error->{code}\n";

    my $details = $error->{detail};
    if(not $details)
    {   # system error, no $details
    }
    exit 1;
}

#--------------------------------------------------------------
$Profile =
# Describing complex tns:Profile
#     {http://avatax.avalara.com/services}Profile
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:xs        http://www.w3.org/2001/XMLSchema

# is a tns:Profile
{ # any attribute in any namespace
  ANYATTR => "AnySimple",

  # sequence of Name, Client, Adapter, Machine

  # is a xs:string
  # is optional
  Name => "example",

  # is a xs:string
  # is optional
  Client => "example",

  # is a xs:string
  # is optional
  Adapter => "example",

  # is a xs:string
  # is optional
  Machine => "example", }

;

#--------------------------------------------------------------
$wsse_Security =
# Describing complex wsse:Security
#     {http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd}Security
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:wsse      http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd
# xmlns:xs        http://www.w3.org/2001/XMLSchema

# is a wsse:SecurityHeaderType
{ # any attribute not in wsse:
  ANYATTR => "AnySimple",

  # sequence of ANY

  # any element in any namespace
  # occurs any number of times
  ANY => [ "Anything", ], }

;

#--------------------------------------------------------------
$parameters =
# Describing complex tns:Validate
#     {http://avatax.avalara.com/services}Validate
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:wsse      http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd

# is an unnamed complex
{ # sequence of ValidateRequest

  # is a tns:ValidateRequest
  # is optional
  ValidateRequest =>
  { # sequence of Address, TextCase, Coordinates, Taxability, Date

    # is a tns:BaseAddress
    # is optional
    Address =>
    { # sequence of AddressCode, Line1, Line2, Line3, City, Region,
      #   PostalCode, Country, TaxRegionId, Latitude, Longitude

      # is a xs:string
      # is optional
      AddressCode => "example",

      # is a xs:string
      # is optional
      Line1 => "example",

      # is a xs:string
      # is optional
      Line2 => "example",

      # is a xs:string
      # is optional
      Line3 => "example",

      # is a xs:string
      # is optional
      City => "example",

      # is a xs:string
      # is optional
      Region => "example",

      # is a xs:string
      # is optional
      PostalCode => "example",

      # is a xs:string
      # is optional
      Country => "example",

      # is a xs:int
      TaxRegionId => 42,

      # is a xs:string
      # is optional
      Latitude => "example",

      # is a xs:string
      # is optional
      Longitude => "example", },

    # is a xs:string
    # Enum: Default Mixed Upper
    TextCase => "Default",

    # is a xs:boolean
    Coordinates => "true",

    # is a xs:boolean
    Taxability => "true",

    # is a xs:date
    Date => "2006-10-06", }, }

;

# Operation PingSoapIn
#           INPUT, document literal
# Produced  by XML::Compile::SOAP11::Operation version 3.08
#           on Wed Mar 11 15:25:00 2015
#
# The output below is only an example: it cannot be used
# without interpretation, although very close to real code.

# Compile only once in your code, usually during initiation:
#   my $call = $wsdl->compileClient('Ping');
# then call it as often as you need.  Alternatively
#   $wsdl->compileCalls();   # once
#   $response = $wsdl->call('Ping', $request);
# The details of the types and elements are attached below.

# Header part 'Profile' is element tns:Profile
my $Profile = {};

# Header part 'wsse_Security' is element wsse:Security
my $wsse_Security = {};

# Body part 'parameters' is element tns:Ping
my $parameters = {};

# Call with the combination of parts.
my @params = (
    Profile => $Profile,
    wsse_Security => $wsse_Security,
    parameters => $parameters,
);
my ($answer, $trace) = $call->(@params);

# @params will become %$data_in in the server handler.
# $answer is a HASH, an operation OUTPUT or Fault.
# $trace is an XML::Compile::SOAP::Trace object.

# You may get an error back from the server
if(my $f = $answer->{Fault})
{   my $errname = $f->{_NAME};
    my $error   = $answer->{$errname};
    print "$error->{code}\n";

    my $details = $error->{detail};
    if(not $details)
    {   # system error, no $details
    }
    exit 1;
}

#--------------------------------------------------------------
$Profile =
# Describing complex tns:Profile
#     {http://avatax.avalara.com/services}Profile
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:xs        http://www.w3.org/2001/XMLSchema

# is a tns:Profile
{ # any attribute in any namespace
  ANYATTR => "AnySimple",

  # sequence of Name, Client, Adapter, Machine

  # is a xs:string
  # is optional
  Name => "example",

  # is a xs:string
  # is optional
  Client => "example",

  # is a xs:string
  # is optional
  Adapter => "example",

  # is a xs:string
  # is optional
  Machine => "example", }

;

#--------------------------------------------------------------
$wsse_Security =
# Describing complex wsse:Security
#     {http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd}Security
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:wsse      http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd
# xmlns:xs        http://www.w3.org/2001/XMLSchema

# is a wsse:SecurityHeaderType
{ # any attribute not in wsse:
  ANYATTR => "AnySimple",

  # sequence of ANY

  # any element in any namespace
  # occurs any number of times
  ANY => [ "Anything", ], }

;

#--------------------------------------------------------------
$parameters =
# Describing complex tns:Ping
#     {http://avatax.avalara.com/services}Ping
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:wsse      http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd

# is an unnamed complex
{ # sequence of Message

  # is a xs:string
  # is optional
  Message => "example", }

;

# Operation IsAuthorizedSoapIn
#           INPUT, document literal
# Produced  by XML::Compile::SOAP11::Operation version 3.08
#           on Wed Mar 11 15:25:00 2015
#
# The output below is only an example: it cannot be used
# without interpretation, although very close to real code.

# Compile only once in your code, usually during initiation:
#   my $call = $wsdl->compileClient('IsAuthorized');
# then call it as often as you need.  Alternatively
#   $wsdl->compileCalls();   # once
#   $response = $wsdl->call('IsAuthorized', $request);
# The details of the types and elements are attached below.

# Header part 'Profile' is element tns:Profile
my $Profile = {};

# Header part 'wsse_Security' is element wsse:Security
my $wsse_Security = {};

# Body part 'parameters' is element tns:IsAuthorized
my $parameters = {};

# Call with the combination of parts.
my @params = (
    Profile => $Profile,
    wsse_Security => $wsse_Security,
    parameters => $parameters,
);
my ($answer, $trace) = $call->(@params);

# @params will become %$data_in in the server handler.
# $answer is a HASH, an operation OUTPUT or Fault.
# $trace is an XML::Compile::SOAP::Trace object.

# You may get an error back from the server
if(my $f = $answer->{Fault})
{   my $errname = $f->{_NAME};
    my $error   = $answer->{$errname};
    print "$error->{code}\n";

    my $details = $error->{detail};
    if(not $details)
    {   # system error, no $details
    }
    exit 1;
}

#--------------------------------------------------------------
$Profile =
# Describing complex tns:Profile
#     {http://avatax.avalara.com/services}Profile
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:xs        http://www.w3.org/2001/XMLSchema

# is a tns:Profile
{ # any attribute in any namespace
  ANYATTR => "AnySimple",

  # sequence of Name, Client, Adapter, Machine

  # is a xs:string
  # is optional
  Name => "example",

  # is a xs:string
  # is optional
  Client => "example",

  # is a xs:string
  # is optional
  Adapter => "example",

  # is a xs:string
  # is optional
  Machine => "example", }

;

#--------------------------------------------------------------
$wsse_Security =
# Describing complex wsse:Security
#     {http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd}Security
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:wsse      http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd
# xmlns:xs        http://www.w3.org/2001/XMLSchema

# is a wsse:SecurityHeaderType
{ # any attribute not in wsse:
  ANYATTR => "AnySimple",

  # sequence of ANY

  # any element in any namespace
  # occurs any number of times
  ANY => [ "Anything", ], }

;

#--------------------------------------------------------------
$parameters =
# Describing complex tns:IsAuthorized
#     {http://avatax.avalara.com/services}IsAuthorized
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:wsse      http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd

# is an unnamed complex
{ # sequence of Operations

  # is a xs:string
  # is optional
  Operations => "example", }

;

# Operation ValidateSoapIn
#           INPUT, document literal
# Produced  by XML::Compile::SOAP12::Operation version 3.03
#           on Wed Mar 11 15:25:00 2015
#
# The output below is only an example: it cannot be used
# without interpretation, although very close to real code.

# Compile only once in your code, usually during initiation:
my $call = $wsdl->compileClient('Validate');
# ... then call it as often as you need.
# The details of the types and elements are attached below.

# Header part 'Profile' is element tns:Profile
my $Profile = {};

# Header part 'wsse_Security' is element wsse:Security
my $wsse_Security = {};

# Body part 'parameters' is element tns:Validate
my $parameters = {};

# Call with the combination of parts.
my @params = (
    Profile => $Profile,
    wsse_Security => $wsse_Security,
    parameters => $parameters,
);
my ($answer, $trace) = $call->(@params);

# @params will become %$data_in in the server handler.
# $answer is a HASH, an operation OUTPUT or Fault.
# $trace is an XML::Compile::SOAP::Trace object.

# You may get an error back from the server
if(my $f = $answer->{Fault})
{   my $errname = $f->{_NAME};
    my $error   = $answer->{$errname};
    print "$error->{code}\n";

    my $details = $error->{detail};
    if(not $details)
    {   # system error, no $details
    }
    exit 1;
}

#--------------------------------------------------------------
$Profile =
# Describing complex tns:Profile
#     {http://avatax.avalara.com/services}Profile
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:xs        http://www.w3.org/2001/XMLSchema

# is a tns:Profile
{ # any attribute in any namespace
  ANYATTR => "AnySimple",

  # sequence of Name, Client, Adapter, Machine

  # is a xs:string
  # is optional
  Name => "example",

  # is a xs:string
  # is optional
  Client => "example",

  # is a xs:string
  # is optional
  Adapter => "example",

  # is a xs:string
  # is optional
  Machine => "example", }

;

#--------------------------------------------------------------
$wsse_Security =
# Describing complex wsse:Security
#     {http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd}Security
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:wsse      http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd
# xmlns:xs        http://www.w3.org/2001/XMLSchema

# is a wsse:SecurityHeaderType
{ # any attribute not in wsse:
  ANYATTR => "AnySimple",

  # sequence of ANY

  # any element in any namespace
  # occurs any number of times
  ANY => [ "Anything", ], }

;

#--------------------------------------------------------------
$parameters =
# Describing complex tns:Validate
#     {http://avatax.avalara.com/services}Validate
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:wsse      http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd

# is an unnamed complex
{ # sequence of ValidateRequest

  # is a tns:ValidateRequest
  # is optional
  ValidateRequest =>
  { # sequence of Address, TextCase, Coordinates, Taxability, Date

    # is a tns:BaseAddress
    # is optional
    Address =>
    { # sequence of AddressCode, Line1, Line2, Line3, City, Region,
      #   PostalCode, Country, TaxRegionId, Latitude, Longitude

      # is a xs:string
      # is optional
      AddressCode => "example",

      # is a xs:string
      # is optional
      Line1 => "example",

      # is a xs:string
      # is optional
      Line2 => "example",

      # is a xs:string
      # is optional
      Line3 => "example",

      # is a xs:string
      # is optional
      City => "example",

      # is a xs:string
      # is optional
      Region => "example",

      # is a xs:string
      # is optional
      PostalCode => "example",

      # is a xs:string
      # is optional
      Country => "example",

      # is a xs:int
      TaxRegionId => 42,

      # is a xs:string
      # is optional
      Latitude => "example",

      # is a xs:string
      # is optional
      Longitude => "example", },

    # is a xs:string
    # Enum: Default Mixed Upper
    TextCase => "Default",

    # is a xs:boolean
    Coordinates => "true",

    # is a xs:boolean
    Taxability => "true",

    # is a xs:date
    Date => "2006-10-06", }, }

;

# Operation PingSoapIn
#           INPUT, document literal
# Produced  by XML::Compile::SOAP12::Operation version 3.03
#           on Wed Mar 11 15:25:00 2015
#
# The output below is only an example: it cannot be used
# without interpretation, although very close to real code.

# Compile only once in your code, usually during initiation:
my $call = $wsdl->compileClient('Ping');
# ... then call it as often as you need.
# The details of the types and elements are attached below.

# Header part 'Profile' is element tns:Profile
my $Profile = {};

# Header part 'wsse_Security' is element wsse:Security
my $wsse_Security = {};

# Body part 'parameters' is element tns:Ping
my $parameters = {};

# Call with the combination of parts.
my @params = (
    Profile => $Profile,
    wsse_Security => $wsse_Security,
    parameters => $parameters,
);
my ($answer, $trace) = $call->(@params);

# @params will become %$data_in in the server handler.
# $answer is a HASH, an operation OUTPUT or Fault.
# $trace is an XML::Compile::SOAP::Trace object.

# You may get an error back from the server
if(my $f = $answer->{Fault})
{   my $errname = $f->{_NAME};
    my $error   = $answer->{$errname};
    print "$error->{code}\n";

    my $details = $error->{detail};
    if(not $details)
    {   # system error, no $details
    }
    exit 1;
}

#--------------------------------------------------------------
$Profile =
# Describing complex tns:Profile
#     {http://avatax.avalara.com/services}Profile
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:xs        http://www.w3.org/2001/XMLSchema

# is a tns:Profile
{ # any attribute in any namespace
  ANYATTR => "AnySimple",

  # sequence of Name, Client, Adapter, Machine

  # is a xs:string
  # is optional
  Name => "example",

  # is a xs:string
  # is optional
  Client => "example",

  # is a xs:string
  # is optional
  Adapter => "example",

  # is a xs:string
  # is optional
  Machine => "example", }

;

#--------------------------------------------------------------
$wsse_Security =
# Describing complex wsse:Security
#     {http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd}Security
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:wsse      http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd
# xmlns:xs        http://www.w3.org/2001/XMLSchema

# is a wsse:SecurityHeaderType
{ # any attribute not in wsse:
  ANYATTR => "AnySimple",

  # sequence of ANY

  # any element in any namespace
  # occurs any number of times
  ANY => [ "Anything", ], }

;

#--------------------------------------------------------------
$parameters =
# Describing complex tns:Ping
#     {http://avatax.avalara.com/services}Ping
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:wsse      http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd

# is an unnamed complex
{ # sequence of Message

  # is a xs:string
  # is optional
  Message => "example", }

;

# Operation IsAuthorizedSoapIn
#           INPUT, document literal
# Produced  by XML::Compile::SOAP12::Operation version 3.03
#           on Wed Mar 11 15:25:00 2015
#
# The output below is only an example: it cannot be used
# without interpretation, although very close to real code.

# Compile only once in your code, usually during initiation:
my $call = $wsdl->compileClient('IsAuthorized');
# ... then call it as often as you need.
# The details of the types and elements are attached below.

# Header part 'Profile' is element tns:Profile
my $Profile = {};

# Header part 'wsse_Security' is element wsse:Security
my $wsse_Security = {};

# Body part 'parameters' is element tns:IsAuthorized
my $parameters = {};

# Call with the combination of parts.
my @params = (
    Profile => $Profile,
    wsse_Security => $wsse_Security,
    parameters => $parameters,
);
my ($answer, $trace) = $call->(@params);

# @params will become %$data_in in the server handler.
# $answer is a HASH, an operation OUTPUT or Fault.
# $trace is an XML::Compile::SOAP::Trace object.

# You may get an error back from the server
if(my $f = $answer->{Fault})
{   my $errname = $f->{_NAME};
    my $error   = $answer->{$errname};
    print "$error->{code}\n";

    my $details = $error->{detail};
    if(not $details)
    {   # system error, no $details
    }
    exit 1;
}

#--------------------------------------------------------------
$Profile =
# Describing complex tns:Profile
#     {http://avatax.avalara.com/services}Profile
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:xs        http://www.w3.org/2001/XMLSchema

# is a tns:Profile
{ # any attribute in any namespace
  ANYATTR => "AnySimple",

  # sequence of Name, Client, Adapter, Machine

  # is a xs:string
  # is optional
  Name => "example",

  # is a xs:string
  # is optional
  Client => "example",

  # is a xs:string
  # is optional
  Adapter => "example",

  # is a xs:string
  # is optional
  Machine => "example", }

;

#--------------------------------------------------------------
$wsse_Security =
# Describing complex wsse:Security
#     {http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd}Security
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:wsse      http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd
# xmlns:xs        http://www.w3.org/2001/XMLSchema

# is a wsse:SecurityHeaderType
{ # any attribute not in wsse:
  ANYATTR => "AnySimple",

  # sequence of ANY

  # any element in any namespace
  # occurs any number of times
  ANY => [ "Anything", ], }

;

#--------------------------------------------------------------
$parameters =
# Describing complex tns:IsAuthorized
#     {http://avatax.avalara.com/services}IsAuthorized
# xmlns:tns       http://avatax.avalara.com/services
# xmlns:wsse      http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd

# is an unnamed complex
{ # sequence of Operations

  # is a xs:string
  # is optional
  Operations => "example", }

;

[DZ] all's well; removing .build/PJ268ZHNId
