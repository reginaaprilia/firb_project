require File.dirname(__FILE__) + '/../test_helper'

class NoteTest < ActiveSupport::TestCase
  
  include TaliaUtil::TestHelpers
  suppress_fixtures
  
  def setup
    setup_once(:flush) do
      TaliaUtil::Util.flush_db
      TaliaUtil::Util.flush_rdf
      true
    end
    
    
    setup_once(:text) do
      source = PiTextCard.create_card(:title => 'Title title title', :parafrasi => 'rollollolllo')
      source.save!
      source
    end
    
    setup_once(:note) do
      note = Note.create_note('I am a note', @text.uri.to_s)
      note.save!
      note
    end
    
    assert_not_nil(@text)
    assert_not_nil(@note)
  end
  
  def test_text_card
    assert_equal(@text.uri, @note.text_card.uri)
  end
  
  def test_content
    assert_equal('I am a note', @note.content)
  end
  
  def test_note_inverse
    assert_equal(1, @text.notes_count)
    assert_equal(@note.uri, @text.notes.first.uri)
  end
  
  def test_replace_notes
    new_card = PiTextCard.create_card(:title => 'Title title title BIS', :parafrasi => 'rollollolllo2')
    new_card.save!
    note = Note.create_note('I am a new note', new_card.uri.to_s)
    note.save!
    Note.replace_notes({ "new_1234" => "bingobong", note.uri.to_s => "pongo" }, new_card)
    new_note = Note.find(note.id)
    new_card = PiTextCard.find(new_card.id)
    assert_equal("pongo", new_note.content)
    assert_equal(2, new_card.notes_count)
  end
  
end