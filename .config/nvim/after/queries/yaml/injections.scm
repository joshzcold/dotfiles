; extends

; --------------- ANSIBLE ------------------------------------------
; Matching ansible '-name: ' for jinja syntax
(block_sequence_item
  (block_node
    (block_mapping
      (block_mapping_pair
        key: (flow_node) @ansible_name
        value: (flow_node
          [
            (plain_scalar
              (string_scalar) @injection.content
            )
            (double_quote_scalar) @injection.content
          ]
        )
        (#set! injection.language "jinja")
      )
    )
  )
  ; Only match yaml block with '- name:' in content
  (#any-of? @ansible_name "name")
) @ansible_task

; Matching ansible block values recursive x2
(block_sequence_item
  (block_node
    (block_mapping
      (block_mapping_pair
        key: (flow_node) @ansible_name
        (#set! injection.language "jinja")
      )
      .
      (block_mapping_pair) * ; any match of block_mapping_pair before main query
      (block_mapping_pair
        value: [
          (block_node
            (block_scalar) @injection.content
          )
          (flow_node
            [
              (plain_scalar
                (string_scalar) @injection.content
              )
              (double_quote_scalar) @injection.content
              (block_node
                (block_scalar) @injection.content
              )
            ]
          )
          (block_node
            (block_mapping
              (block_mapping_pair
                value: [
                  (flow_node
                    [
                      (plain_scalar
                        (string_scalar) @injection.content
                      )
                      (double_quote_scalar) @injection.content
                      (block_node
                        (block_scalar) @injection.content
                      )
                    ]
                  )
                  (block_node
                    [
                      (block_mapping
                        (block_mapping_pair
                          value: [
                            (flow_node
                              [
                                (plain_scalar
                                  (string_scalar) @injection.content
                                )
                                (double_quote_scalar) @injection.content
                              ]
                            )
                            (block_node
                              (block_scalar) @injection.content
                            )
                          ]
                        )
                      )
                      (block_scalar) @injection.content
                    ]
                  )
                ]
              )
            )
          ) @possible_value
        ]
      )
    )
  )
  ; Only match yaml block with '- name:' in content
  (#any-of? @ansible_name "name")
  (#set! injection.language "jinja")
) @ansible_task
