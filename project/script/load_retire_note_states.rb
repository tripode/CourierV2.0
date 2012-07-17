RetireNoteState.transaction do
  RetireNoteState.create(:state_name => "Procesado")
  RetireNoteState.create(:state_name => "En Proceso")
  RetireNoteState.create(:state_name => "Cancelado")
end