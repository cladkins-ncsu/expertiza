class SectionHeader < QuestionnaireHeader
  def complete(_count, _answer = nil)
    safe_join(make_header << '<br/><br/>')
  end

  def view_completed_question(_count, _answer)
    safe_join(make_header)
  end

  private def make_header
    ['<b style="color: #986633; font-size: x-large">',
     self.txt,
     '</b>']
  end
end
