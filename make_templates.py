"""Build valid, blank Office templates packaged as application resources."""
from pathlib import Path
from docx import Document
from openpyxl import Workbook
from pptx import Presentation
p=Path(__file__).parent/'Templates'
p.mkdir(exist_ok=True)
d=Document(); d.add_paragraph(); d.save(p/'Blank.docx')
w=Workbook(); w.active.title='Sheet1'; w.save(p/'Blank.xlsx')
s=Presentation(); s.slides.add_slide(s.slide_layouts[6]); s.save(p/'Blank.pptx')
# Reopen to ensure all relationships and content are loadable.
assert len(Document(p/'Blank.docx').paragraphs)==1
assert Workbook is not None
from openpyxl import load_workbook
assert load_workbook(p/'Blank.xlsx').active['A1'].value is None
assert len(Presentation(p/'Blank.pptx').slides)==1
print('PASS: blank DOCX / XLSX / PPTX templates reopen')
