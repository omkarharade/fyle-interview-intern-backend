from flask import jsonify
from flask import Blueprint
from core import db
from core.apis import decorators
from core.apis.responses import APIResponse
from core.models.assignments import Assignment

from .schema import AssignmentSchema, AssignmentSubmitSchema, AssignmentGradeSchema
from core.apis.teachers.schema import TeacherSchema
principal_assignments_resources = Blueprint('principal_assignments_resources', __name__)


@principal_assignments_resources.route('/assignments', methods=['GET'], strict_slashes=False)
@decorators.authenticate_principal
def list_assignments(p):
    """Returns list of assignments"""
    assignment_list  = Assignment.get_assignments_by_principal()
    assignment_list_dump = AssignmentSchema().dump(assignment_list, many=True)
    return APIResponse.respond(data=assignment_list_dump)



@principal_assignments_resources.route('/teachers', methods=['GET'], strict_slashes=False)
@decorators.authenticate_principal
def list_teachers(p):
    """Returns list of teachers"""
    teachers_list  = Assignment.get_all_teachers()
    teachers_list_dump = TeacherSchema().dump(teachers_list, many=True)
    return APIResponse.respond(data=teachers_list_dump)



@principal_assignments_resources.route('/assignments/grade', methods=['POST'], strict_slashes=False)
@decorators.accept_payload
@decorators.authenticate_principal
def grade_assignment(p, incoming_payload):
    """Grade an assignment"""
    grade_assignment_payload = AssignmentGradeSchema().load(incoming_payload)

    graded_assignment = Assignment.mark_grade_by_Principal(
        _id=grade_assignment_payload.id,
        grade=grade_assignment_payload.grade,
        auth_principal=p
    )

    graded_assignment_dump = AssignmentSchema().dump(graded_assignment)
    db.session.commit()
    
    return APIResponse.respond(data=graded_assignment_dump)

@principal_assignments_resources.route('/assignments/check', methods=['GET'], strict_slashes=False)
def check():

    response = jsonify({
        'status': 'ready',
    })
    return response