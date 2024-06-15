//
//  FileView.swift
//  diploma
//
//  Created by Evelina on 15.02.2024.
//

import SwiftUI
import Splash
import AxisTooltip

struct FileView: View {
    @Binding var viewFile: DFile?
    @State var errors: [MetricErrorData]?
    @Binding var projectErrors: Dictionary<String, [MetricErrorData]>?
    @Binding var selectedProject: Project?
    @Binding var projectInfo: ProjectInfo?
    let viewModel: FileViewModel
    
    
    let highlighter = SyntaxHighlighter(format: AttributedStringOutputFormat(theme:  .sundellsColors(withFont: Font(size: 16.0))))
    @State var isPresented: Bool = false
    @State private var constant: ATConstant = .init(axisMode: .leading,border: ATBorderConstant(color: .red), arrow: ATArrowConstant(width: 6, height: 6))
    
    var body: some View {
        if let file = viewFile {
            let text = String(data: file.data, encoding: .utf8) ?? ""
            let lines = file.lines
            let lineError = errors?.reduce(into: [Int: MetricErrorData]()) { (result, error) in
                result[error.range.start] = error
            } ?? [:]
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(lines.indices, id: \.self) { index in
                        let line = lines[index]
                        let string = highlighter.highlight(line)
                        let isErrorLine = lineError[index + 1] == nil ? false : true
                        let isWarning = lineError[index + 1]?.canFixError == false ? true : false
                        HStack {
                            Text("\(index + 1)")
                                .font(.caption)
                                .padding(.trailing, 6)
                            Text(AttributedString(string))
                                .font(.title3)
                                .multilineTextAlignment(.center)
                            Spacer()
                            if isErrorLine, let error = lineError[index + 1] {
                                ZStack(alignment: .trailing) {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .frame(alignment: .trailing)
                                        .foregroundColor(error.canFixError ? .red : .yellow)
                                        .padding(.horizontal, 6)
                                        .onTapGesture {
                                            isPresented.toggle()
                                        }
                                    Rectangle()
                                        .frame(width: 0, height: 0)
                                        .axisToolTip(isPresented: $isPresented, alignment: .leadingLastTextBaseline, constant: constant, background: {
                                            Rectangle()
                                                .fill(Color.black.opacity(1.0))
                                                .background(Color.black.opacity(1.0))
                                          }, foreground: {
                                              VStack {
                                                  Text(error.type.errorMessage)
                                                      .padding(.vertical, 6)
                                                      .frame(width: 200)
                                                  Button("Fix") {
                                                      viewModel.fixError(file: file, error: error) { dfile, warning  in
                                                          if let warning = warning {
                                                              let index = errors?.firstIndex(where: {$0.id == error.id})
                                                              error.canFixError = false
                                                              error.type = warning.type
                                                              errors?[index ?? 0] = error
                                                          } else {
                                                              viewFile = dfile
                                                              projectErrors?[file.path]?.removeAll(where: {$0.id == error.id})
                                                              if projectErrors?[file.path] == [] {
                                                                  projectErrors?.removeValue(forKey: file.path)
                                                              }
                                                          }
                                                      }
                                                  }
                                                  .opacity(error.canFixError ? 1 : 0)
                                              }
//                                              .fixedSize()
                                              .padding(6)
                                        })
                                }
                                .fixedSize()
                            } 
                        }
                        .background(isErrorLine ? Color.red.opacity(0.1) : .clear)
                        .background(isWarning ? Color.yellow.opacity(0.1) : .clear)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .onTapGesture {
                isPresented = false
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 16)
        }
    }
}
