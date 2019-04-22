--
-- File generated with SQLiteStudio v3.2.1 on Sun Apr 21 23:45:52 2019
--
-- Text encoding used: System
--
PRAGMA foreign_keys = off;
BEGIN TRANSACTION;

-- Table: ACTOR
DROP TABLE IF EXISTS ACTOR;

CREATE TABLE ACTOR (
    ActorID    INT  NOT NULL,
    Name       TEXT NOT NULL,
    EditableID INT  NOT NULL,
    PRIMARY KEY (
        ActorID
    ),
    FOREIGN KEY (
        EditableID
    )
    REFERENCES EDITABLE (EditableID) 
);


-- Table: ALBUM
DROP TABLE IF EXISTS ALBUM;

CREATE TABLE ALBUM (
    AlbumID  INT          UNIQUE
                          NOT NULL,
    ArtistID INT          NOT NULL,
    Label    VARCHAR (15),
    PRIMARY KEY (
        AlbumID
    ),
    FOREIGN KEY (
        AlbumID
    )
    REFERENCES Media_production (ProductionID),
    FOREIGN KEY (
        ArtistID
    )
    REFERENCES Artist (ArtistID) 
);


-- Table: ARTIST
DROP TABLE IF EXISTS ARTIST;

CREATE TABLE ARTIST (
    ArtistID   INT  NOT NULL,
    Name       TEXT NOT NULL,
    EditableID INT  NOT NULL,
    PRIMARY KEY (
        ArtistID
    ),
    FOREIGN KEY (
        EditableID
    )
    REFERENCES EDITABLE (EditableID) 
);


-- Table: CHECKS_OUT
DROP TABLE IF EXISTS CHECKS_OUT;

CREATE TABLE CHECKS_OUT (
    CheckoutID    INT      NOT NULL,
    ProductionID  INT      NOT NULL,
    CardNo        INT      NOT NULL,
    Returned      CHAR (1) NOT NULL,
    CDate         DATE     NOT NULL,
    Duration_Days INT      NOT NULL,
    PRIMARY KEY (
        CheckoutID
    ),
    FOREIGN KEY (
        ProductionID
    )
    REFERENCES MEDIA_PRODUCTION (ProductionID),
    FOREIGN KEY (
        CardNo
    )
    REFERENCES LIBRARY_CARD (CardNo) 
);


-- Table: CUSTOMER
DROP TABLE IF EXISTS CUSTOMER;

CREATE TABLE CUSTOMER (
    CustID    INT          NOT NULL,
    FullName  VARCHAR (30) NOT NULL,
    Address   VARCHAR (30),
    Phone     INT,
    Birthdate DATE,
    Sex       CHAR (1),
    PRIMARY KEY (
        CustID
    )
);


-- Table: DIGITAL_COPY
DROP TABLE IF EXISTS DIGITAL_COPY;

CREATE TABLE DIGITAL_COPY (
    LicenseNo    INT NOT NULL,
    Size_Bytes   INT NOT NULL,
    ProductionID INT NOT NULL,
    PRIMARY KEY (
        LicenseNo
    ),
    FOREIGN KEY (
        ProductionID
    )
    REFERENCES MEDIA_PRODUCTION (ProductionID) 
);


-- Table: DIRECTOR
DROP TABLE IF EXISTS DIRECTOR;

CREATE TABLE DIRECTOR (
    DirectorID INT  NOT NULL,
    Name       TEXT NOT NULL,
    EditableID INT  NOT NULL,
    PRIMARY KEY (
        DirectorID
    ),
    FOREIGN KEY (
        EditableID
    )
    REFERENCES EDITABLE (EditableID) 
);


-- Table: EDITABLE
DROP TABLE IF EXISTS EDITABLE;

CREATE TABLE EDITABLE (
    EditableID INT NOT NULL,
    PRIMARY KEY (
        EditableID
    )
);


-- Table: EMPLOYEE
DROP TABLE IF EXISTS EMPLOYEE;

CREATE TABLE EMPLOYEE (
    EmpID     INT          NOT NULL,
    FullName  VARCHAR (30) NOT NULL,
    Address   VARCHAR (30),
    Phone     INT,
    Birthdate DATE,
    Sex       CHAR (1),
    PRIMARY KEY (
        EmpID
    )
);


-- Table: LIBRARY_CARD
DROP TABLE IF EXISTS LIBRARY_CARD;

CREATE TABLE LIBRARY_CARD (
    CardNo     INT      NOT NULL,
    Status     CHAR (1) NOT NULL,
    RDate      DATE     NOT NULL,
    CustID     INT      NOT NULL,
    EditableID INT      NOT NULL,
    PRIMARY KEY (
        CardNo
    ),
    FOREIGN KEY (
        CustID
    )
    REFERENCES CUSTOMER (CustID),
    FOREIGN KEY (
        EditableID
    )
    REFERENCES EDITABLE (EditableID) 
);


-- Table: MEDIA_PRODUCTION
DROP TABLE IF EXISTS MEDIA_PRODUCTION;

CREATE TABLE MEDIA_PRODUCTION (
    ProductionID INT         NOT NULL,
    Name         TEXT        NOT NULL,
    Genre        TEXT,
    Length_Secs  INT,
    Year         INT,
    Type         VARCHAR (5) NOT NULL,
    EditableID   INT         NOT NULL,
    PRIMARY KEY (
        ProductionID
    ),
    FOREIGN KEY (
        EditableID
    )
    REFERENCES EDITABLE (EditableID) 
);


-- Table: MOVIE
DROP TABLE IF EXISTS MOVIE;

CREATE TABLE MOVIE (
    MovieID        INT      NOT NULL,
    Content_Rating CHAR (1),
    ActorID        INT      NOT NULL,
    DirectorID     INT      NOT NULL,
    PRIMARY KEY (
        MovieID
    ),
    FOREIGN KEY (
        MovieID
    )
    REFERENCES MEDIA_PRODUCTION (ProductionID),
    FOREIGN KEY (
        ActorID
    )
    REFERENCES ACTOR (ActorID),
    FOREIGN KEY (
        DirectorID
    )
    REFERENCES DIRECTOR (DirectorID) 
);


-- Table: PHYSICAL_COPY
DROP TABLE IF EXISTS PHYSICAL_COPY;

CREATE TABLE PHYSICAL_COPY (
    InventoryTag INT  NOT NULL,
    Format       TEXT NOT NULL,
    ProductionID INT  NOT NULL,
    PRIMARY KEY (
        InventoryTag
    ),
    FOREIGN KEY (
        ProductionID
    )
    REFERENCES MEDIA_PRODUCTION (ProductionID) 
);


-- Table: ROLE
DROP TABLE IF EXISTS ROLE;

CREATE TABLE ROLE (
    MovieID INT  NOT NULL,
    Name    TEXT NOT NULL,
    ActorID INT  NOT NULL,
    PRIMARY KEY (
        MovieID,
        Name
    ),
    FOREIGN KEY (
        MovieID
    )
    REFERENCES MOVIE (MovieID),
    FOREIGN KEY (
        ActorID
    )
    REFERENCES ACTOR (ActorID) 
);


-- Table: TRACK
DROP TABLE IF EXISTS TRACK;

CREATE TABLE TRACK (
    TrackID  INTEGER PRIMARY KEY
                     NOT NULL
                     REFERENCES MEDIA_PRODUCTION (ProductionID),
    AlbumID  INTEGER REFERENCES ALBUM (AlbumID) 
                     NOT NULL,
    ArtistID INTEGER REFERENCES ARTIST (ArtistID) 
                     NOT NULL,
    TrackNo  INTEGER
);


-- Index: CHECKED_OUT_TO
DROP INDEX IF EXISTS CHECKED_OUT_TO;

CREATE INDEX CHECKED_OUT_TO ON CHECKS_OUT (
    CardNo
);


-- Index: CUST_LIBRARY_CARD
DROP INDEX IF EXISTS CUST_LIBRARY_CARD;

CREATE INDEX CUST_LIBRARY_CARD ON LIBRARY_CARD (
    CustID
);


-- Index: PRODUCTION_NAME
DROP INDEX IF EXISTS PRODUCTION_NAME;

CREATE INDEX PRODUCTION_NAME ON MEDIA_PRODUCTION (
    Name
);


-- View: INVENTORY
DROP VIEW IF EXISTS INVENTORY;
CREATE VIEW INVENTORY (
    ProductionID,
    Title,
    Type,
    Number
)
AS
    SELECT ProductionID,
           Name,
           Type,
           COUNT(Tag) 
      FROM (
               SELECT M.ProductionID,
                      M.Name,
                      M.Type,
                      P.InventoryTag AS Tag
                 FROM Media_Production AS M,
                      Physical_Copy AS P
                WHERE P.ProductionID = M.ProductionID
               UNION
               SELECT M.ProductionID,
                      M.Name,
                      M.Type,
                      D.LicenseNo AS Tag
                 FROM Media_Production AS M,
                      Digital_Copy AS D
                WHERE D.ProductionID = M.ProductionID
           )
     GROUP BY ProductionID
     ORDER BY 4 DESC;


-- View: OUTSTANDING_CHECKOUTS
DROP VIEW IF EXISTS OUTSTANDING_CHECKOUTS;
CREATE VIEW OUTSTANDING_CHECKOUTS (
    Customer,
    CardNo,
    Title,
    CDate,
    Duration
)
AS
    SELECT C.FullName,
           L.CardNo,
           M.Name,
           CO.CDate,
           CO.Duration_Days
      FROM Customer AS C,
           Library_Card AS L,
           Checks_Out AS CO,
           Media_Production AS M
     WHERE L.CustID = C.CustID AND 
           L.Status = 'Y' AND 
           CO.CardNo = L.CardNo AND 
           CO.ProductionID = M.ProductionID AND 
           CO.Returned = 'N';


-- View: POPULAR_MEDIA
DROP VIEW IF EXISTS POPULAR_MEDIA;
CREATE VIEW POPULAR_MEDIA (
    ID,
    Title,
    Type,
    Genre,
    Checkout_Count
)
AS
    SELECT M.ProductionID,
           M.Name,
           M.Type,
           M.Genre,
           COUNT(M.ProductionID) AS cnt
      FROM Media_Production AS M,
           Checks_Out AS C
     WHERE M.ProductionID = C.ProductionID
     GROUP BY M.ProductionID
     ORDER BY cnt DESC;


COMMIT TRANSACTION;
PRAGMA foreign_keys = on;
