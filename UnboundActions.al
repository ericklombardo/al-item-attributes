codeunit 50100 "My Unbound Action API"
{
    procedure Ping(): Text
    begin
        exit('Pong');
    end;

    procedure GetFirstCustomerName(): Text
    var
        Cust: Record Customer;
    begin
        Cust.FindFirst();
        exit(Cust.Name);
    end;
}