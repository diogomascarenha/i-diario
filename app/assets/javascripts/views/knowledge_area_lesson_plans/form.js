window['content_list_model_name'] = 'knowledge_area_lesson_plan';
window['content_list_submodel_name'] = 'lesson_plan';

$(function () {
  'use strict';
  const copyTeachingPlanLink = document.getElementById('copy-from-teaching-plan-link');
  const startAtInput = document.getElementById('knowledge_area_lesson_plan_lesson_plan_attributes_start_at');
  const endAtInput = document.getElementById('knowledge_area_lesson_plan_lesson_plan_attributes_end_at');
  const knowledgeAreasInput = document.getElementById('knowledge_area_lesson_plan_knowledge_area_ids');
  const copyFromTeachingPlanAlert = document.getElementById('lesson_plan_copy_from_teaching_plan_alert');
  const flashMessages = new FlashMessages();

  $('#knowledge_area_lesson_plan_lesson_plan_attributes_contents_tags').on('change', function(e){
    if(e.val.length){
      var content_description = e.val.join(", ");
      if(content_description.trim().length &&
          !$('input[type=checkbox][data-content_description="'+content_description+'"]').length){

        var html = JST['templates/layouts/contents_list_manual_item']({
          description: content_description,
          model_name: 'knowledge_area_lesson_plan',
          submodel_name: 'lesson_plan'
        });

        $('#contents-list').append(html);
        $('.list-group.checked-list-box .list-group-item:not(.initialized)').each(initializeListEvents);
      }else{
        var content_input = $('input[type=checkbox][data-content_description="'+content_description+'"]');
        content_input.closest('li').show();
        content_input.prop('checked', true).trigger('change');
      }

      $('.knowledge_area_lesson_plan_lesson_plan_contents_tags .select2-input').val("");
    }
    $(this).select2('val', '');
  });

  $('#knowledge_area_lesson_plan_lesson_plan_attributes_objectives_tags').on('change', function(e){
    if(e.val.length){
      var objective_description = e.val.join(", ");
      if(objective_description.trim().length &&
          !$('input[type=checkbox][data-objective_description="'+objective_description+'"]').length){

        var html = JST['templates/layouts/objectives_list_manual_item']({
          description: objective_description,
          model_name: 'knowledge_area_lesson_plan',
          submodel_name: 'lesson_plan'
        });

        $('#objectives-list').append(html);
        $('.list-group.checked-list-box .list-group-item:not(.initialized)').each(initializeListEvents);
      }else{
        var objective_input = $('input[type=checkbox][data-objective_description="'+objective_description+'"]');
        objective_input.closest('li').show();
        objective_input.prop('checked', true).trigger('change');
      }

      $('.knowledge_area_lesson_plan_lesson_plan_objectives_tags .select2-input').val("");
    }
    $(this).select2('val', '');
  });

  const addElement = (description) => {
    if(!$('li.list-group-item.active input[type=checkbox][data-content_description="'+description+'"]').length) {
      const newLine = JST['templates/layouts/contents_list_manual_item']({
        description: description,
        model_name: window['content_list_model_name'],
        submodel_name: window['content_list_submodel_name']
      });

      $('#contents-list').append(newLine);
      $('.list-group.checked-list-box .list-group-item:not(.initialized)').each(initializeListEvents);
    }
  };

  const fillContents = (data) => {
    if (data.knowledge_area_lesson_plans.length) {
      data.knowledge_area_lesson_plans.forEach(content => addElement(content.description));
    } else {
      copyFromTeachingPlanAlert.style.display = 'block';
    }
  }

  copyTeachingPlanLink.addEventListener('click', event => {
    event.preventDefault();
    copyFromTeachingPlanAlert.style.display = 'none';

    if (!knowledgeAreasInput.value) {
      flashMessages.error('É necessário preenchimento das áreas de conhecimento para realizar a cópia.');
      return false;
    }

    if (!startAtInput.value || !endAtInput.value) {
      flashMessages.error('É necessário preenchimento das datas para realizar a cópia.');
      return false;
    }
    const url = Routes.teaching_plan_contents_knowledge_area_lesson_plans_pt_br_path();
    const params = {
      knowledge_area_ids: knowledgeAreasInput.value,
      start_date: startAtInput.value,
      end_date: endAtInput.value
    }

    $.getJSON(url, params)
    .done(fillContents);


    return false;
  });
});
