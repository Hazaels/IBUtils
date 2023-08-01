object fraMain: TfraMain
  Left = 0
  Top = 0
  Width = 142
  Height = 178
  Constraints.MinHeight = 20
  Constraints.MinWidth = 20
  TabOrder = 0
  OnMouseDown = FrameMouseDown
  OnMouseUp = FrameMouseUp
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 142
    Height = 178
    Align = alClient
    BevelInner = bvRaised
    TabOrder = 0
    OnMouseDown = pnlMainMouseDown
    OnMouseMove = pnlMainMouseMove
    OnMouseUp = pnlMainMouseUp
  end
end
