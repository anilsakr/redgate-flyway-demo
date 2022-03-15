CREATE TABLE [ref].[Barlines]
(
[BarlineID] [nvarchar] (255) NOT NULL,
[BarlineName] [nvarchar] (255) NULL,
[PlaneType] [float] NULL,
[MinorModel] [nvarchar] (255) NULL,
[Airstair] [bit] NULL,
[Model] [nvarchar] (255) NULL,
[Day] [int] NOT NULL,
[Shift] [int] NULL,
[Position] [nvarchar] (255) NULL,
[NumStations] [int] NULL,
[AreaID] [nvarchar] (50) NOT NULL,
[SubAreaID] [nvarchar] (50) NOT NULL,
[NumberMechanics] [int] NOT NULL,
[CreatedOn] [datetime2] NULL,
[CreatedBy] [nvarchar] (255) NULL,
[ModifiedOn] [datetime2] NULL,
[ModifiedBy] [nvarchar] (255) NULL,
[Line] [varchar] (10) NULL,
[description] [varchar] (255) NOT NULL CONSTRAINT [DF__Barlines__descri__6B44E613] DEFAULT ('NA')
)
GO
ALTER TABLE [ref].[Barlines] ADD CONSTRAINT [PK__Barlines__A04047B57916AEBC] PRIMARY KEY CLUSTERED ([BarlineID])
GO
