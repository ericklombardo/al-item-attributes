query 50101 "Vendor Item Numbers"
{
    elements
    {
        dataitem(Item_Cross_Reference; "Item Cross Reference")
        {
            DataItemTableFilter = "Cross-Reference Type" = CONST(Vendor);
            column(Unit_of_Measure; "Unit of Measure")
            {

            }
            column(Description; Description)
            {

            }
            column(Description_2; "Description 2")
            {

            }
            column(Item_No; "Item No.")
            {

            }
            column(Cross_Reference_Type_No; "Cross-Reference Type No.")
            {

            }
            column(Cross_Reference_No; "Cross-Reference No.")
            {

            }
            dataitem(Item; Item)
            {
                DataItemLink = "No." = Item_Cross_Reference."Item No.";
                column(Preferred_Vendor_No; "Vendor No.")
                {

                }
            }
        }
    }
}